require 'csv'

class CsvDb
  class << self
    def search_by_name_and_fk(foreignKey, name_in)
      conversion = Hash.new(nil)
      conversion = { "book_id" => "asin", 
                     "purchase_order_id" => "po_number",
                     "account_id" => "acc_number",
                     "device_id" => "serial_number",
                     "student_id" => "other_names",
                     "push_id" => "date"
                    }

      n = conversion[foreignKey]

      if n == nil then
        n = "name"
      end

      method_name = "find_by_" + n
      if foreignKey.eql?("book_status_id")
        modeln = "BookStatus"
        id_out = BookStatus.send("find_by_name", name_in)
      else
        modeln = foreignKey[0..-4].classify.constantize
        id_out = modeln.send( method_name, name_in)
      end
      
    end



    def convert_save(model_name, csv_data)
      csv_file = csv_data.read # this returns an array of arrays ["Europe"]["USA"][...]
      CSV.parse(csv_file) do |row|
        target_model = model_name.classify.constantize
        new_object = target_model.new
        # NOTE: column_iterator MUST begin in -1 since the column "ID" is ENFORCED to be at index 0
        column_iterator = -1
        target_model.column_names.each do |key|
          unless key == "id"
            value = row[column_iterator]
            if key[-3, 3] == "_id" then
              valuet = search_by_name_and_fk(key, value)
              if valuet.nil?
                value = -1 # "---ERROR---"
              else
                value = valuet.id
              end
            end
            new_object.send "#{key}=", value
          end
          column_iterator += 1
        end
        new_object.save
      end
    end

  def convert_save_books(csv_data)
      csv_file = csv_data.read # this returns an array of arrays ["Europe"]["USA"][...]
      err = []
      target_model = Book
      CSV.parse(csv_file) do |row|
        new_object = nil
        new_object = target_model.new
        # NOTE: column_iterator MUST begin in -1 since the column "ID" is ENFORCED to be at index 0
        column_iterator = -1
        target_model.column_names.each do |key|
          unless key == "id"
            value = row[column_iterator]
            if key[-3, 3] == "_id" then
              valuet = search_by_name_and_fk(key, value)
              if valuet.nil?
                value = 0 # "---ERROR---"
              else
                value = valuet.id
              end
            end
            new_object.send "#{key}=", value
          end
          column_iterator += 1
        end
        if new_object.valid? then
          new_object.save

          value = row[column_iterator]
          auth_id = Author.send("find_by_name", value)
          new_object.authors << auth_id
          column_iterator += 1
          value = row[column_iterator]
          values = value.split("/")
          arr_siz = values.size
          values.size.times do
            l_id = Level.find_by_name(values[values.size - arr_siz])
            new_object.levels << l_id
            arr_siz = arr_siz -1
          end
        else
          errs << row
          break
        end

      end  

        # Export Error file for later upload upon correction
      if errs.any?
        errFile ="errors_#{Date.today.strftime('%d%b%y')}.csv"
        errs.insert(0, Book.csv_header)
        errCSV = CSV.generate do |csv|
          errs.each {|row| csv << row}
        end
        send_data errCSV,
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=#{errFile}.csv"
      else
        flash[:notice] = I18n.t('book.import.success')
        redirect_to import_url #GET
      end
      
    end
  end
end

