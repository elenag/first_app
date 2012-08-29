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
      modeln = foreignKey[0..-4].classify.constantize
      id_out = modeln.send( method_name, name_in)
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
  end
end

