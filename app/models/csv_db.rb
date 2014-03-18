require 'csv'

class String
  def numeric?
    return true if self =~ /^\d+$/
    true if Float(self) rescue false
  end
end 

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

    def convert_kdp_download(start_date,end_date,publisherid,yearofreport)
      @bookidarr = Book.select('distinct books.id,publishers.name as pubname').joins(:publisher).where("publisher_id=?",publisherid).limit(nil)
    
      kdpfilter = KdpReport.select("kdp_reports.*,books.price,publishers.name").joins(:book,:publisher).where("(start_date >= ? and end_date <= ?) and kdp_reports.book_id in (?)",start_date,end_date, @bookidarr).limit(nil)    
	testdb = ("SELECT books.asin,books.title,projects.name,count(pushes.book_id) as total_unit_s FROM books 
INNER JOIN `pushes` ON `pushes`.`book_id` = `books`.`id` 
INNER JOIN `content_buckets` ON `content_buckets`.`id` = `pushes`.`content_bucket_id` 
INNER JOIN `projects` ON `projects`.`id` = `content_buckets`.`project_id` 
INNER JOIN `publishers` ON `publishers`.`id` = `books`.`publisher_id` 
INNER JOIN content_buckets_homerooms ON content_buckets_homerooms.content_bucket_id = content_buckets.id 
INNER JOIN accounts ON accounts.homeroom_id = content_buckets_homerooms.homeroom_id 
INNER JOIN devices ON devices.account_id = accounts.id 
WHERE  (pushes.push_date between '#{start_date}' and '#{end_date}' AND `books`.`id` >= 0 AND books.publisher_id = '#{publisherid}' )  
GROUP BY asin,projects.name ORDER BY books.title ASC LIMIT 5000")
	conn = Mysql2::Client.new(:host => "localhost", :username => "worldreader", :password => "totKoirIvnavwuds", :database => "worldreader")
	results = conn.query(testdb)
      #kdpfilter_sold = Book.select("books.asin,books.title,projects.name as Project,publishers.id,count(pushes.book_id) as total_unit_s").joins(:pushes,:content_buckets,:projects,:publisher,:content_buckets_homerooms,:accounts,:devices).where("(push_date >= ? and push_date <= ?) AND publishers.id in (?)",start_date,end_date,publisherid).group(:asin)
	# Orginal Line
      #kdpfilter_sold = Book.select("books.asin,books.title,projects.name as pro_name,sum(pushes.book_id) as total_unit_s").joins(:projects).where("(push_date >= ? and push_date <= ?)",start_date,end_date).group(:asin)
      # kdpfilter_sold = Book.select("books.asin,books.title,projects.name as pro_name,sum(pushes.book_id) as total_unit_s").joins(:publisher,:projects).where("(push_date >= ? and push_date <= ?) and books.publisher_id=?",start_date,end_date,publisherid).group(:asin).limit(nil)
     
      sumofdonate=0.00;
      t = Time.now
      csvfilename= 'KDP_file.csv'      
      CSV.open(Rails.root.to_s+"/csvdownload/"+csvfilename, "wb") do |csv|
        
        csv << [ (@bookidarr[0]['pubname']).to_s + " - Q " + yearofreport + " Sales",""]       
        csv << ["Prior Royalty Balance","$-"]
        csv << ["Payments","$-"]
        csv << ["Partner Programs Royalty Balance","$-"]
        csv << ["Retail Sales Royalty Balance","$-"]
        csv << ["Total Royalty Balance","$-"]
        csv << ["",""]
        csv << ["Sales to Worldreader Partner Programs Q1 " + yearofreport  ,""]
        csv << ["ASIN","Title","Project","Total Units Sold","Royalty"]
        
  	results.each(:cache_rows => false) do |row|
  	      csv << [row.values]
  	end
        #kdpfilter_sold.find_each do |kdp_report_sold|
        # csv << [kdp_report_sold.asin,kdp_report_sold.title,kdp_report_sold.pro_name,kdp_report_sold.total_unit_s]
        #end
             
        csv << ["","","","","$-"]
        csv << ["",""]
        csv << ["",""]
   
        csv << ["Retail Sales Q1 2013 - from consolidated Amazon KDP reports"]
        csv << ["*Amazon 35% transactions are in their foreign stores, Worldreader has no control over this"]
        csv << ["**net units sold  - sales less refunds"]
        csv << ["note:  Books listed twice were either sold in different months OR in different Amazon stores (different countries)"]
        csv << ["Asin","Month Sold","Title","Transaction Type","Net Units Sold","Average Delivery Cost","Royalty","Store","Currency","exchange rate","USD Net","Owed to publisher"]
     
        kdpfilter.find_each do |kdp_report|
          booktitle = kdp_report.book.title rescue nil
          asinnumb = kdp_report.book.asin rescue nil         
          csv << [ asinnumb,kdp_report.month_sold,booktitle,kdp_report.transaction_type,kdp_report.net_units_sold_or_borrowed,kdp_report.average_delivery_cost,kdp_report.royalty,kdp_report.store,"","","",""]
        end
        csv << ["","","","","","","","","","","","$-"]
      end
      return csvfilename
    end


    # 
    def download_donaterpt_csv(start_date,end_date,yearofreport)
      # @bookidarr = Book.select('distinct books.id,publishers.name as pubname').joins(:publisher).where("publisher.free=?","free")      
         
      bookdontated = Book.select("books.asin, books.price, books.title, publishers.name as publisher_name, projects.name as pro_name,categories.name as catry_name,sum(pushes.book_id) as total_unit_s").joins(:category,:publisher,:projects).where("(push_date >= ? and push_date <= ?) and publishers.free=?",start_date,end_date,"free").group(:asin)
     
      sumofdonate=0.00;
      t = Time.now
      csvfilename= 'DonatedReport.csv'
      CSV.open(Rails.root.to_s+"/csvdownload/"+csvfilename, "wb") do |csv|
        
        csv << ["ASIN","Title","Publisher","Project","Category","Price","Total Units","Donated Reports"]
        
        bookdontated.find_each do |booksrcd|
        donatedvalue = (booksrcd.total_unit_s.to_f * booksrcd.price.to_f)
        csv << [booksrcd.asin,booksrcd.title,booksrcd.publisher_name,booksrcd.pro_name,booksrcd.catry_name,booksrcd.price,booksrcd.total_unit_s,donatedvalue]
        sumofdonate = sumofdonate.to_f + donatedvalue.to_f

        end             
       
        csv << ["","","","","","","$-",sumofdonate]
      end
      return csvfilename
    end

=begin

    def textbook_level_download(originid)
      csvfilename='textbook_coverage_rpt.csv'

      textbook_level_query=("SELECT name FROM textbook_levels WHERE name LIKE 'Standard%'")
      conn = Mysql2::Client.new(:host => "localhost",:username => "root",:password=> "password123",:database=>"wrdatabase")
      textbooklevelarr = conn.query(textbook_level_query)

      categoryarr = Category.where(id=3)

      textbook_subj_query=("SELECT name FROM textbook_subjects WHERE id IN ('8','6','27','19','22','2','5','1','21')")
      standardlookuparr = conn.query(textbook_subj_query)

     # standardlookuparr = textbook_subjects.where(id:[8,6,27,19,22,2,5,1,21])
      standardlookupheadarr = standardlookuparr.name rescue nil


      CSV.open(Rails.root.to_s+"/csvdownload/"+csvfilename,"wb") do |csv|

        if originid != 0 && originid != "All"
          originsarr = Origin.where("id=?",originid)
        else
          originsarr=Origin.find(:all)
        end


        originsarr.each do |origin|
          if Book.where("origin_id=?",origin.id).count>0
            originname = origin.name rescue nil
            csv << [originname]


            columns = ' '
            standardlookuparr.each do |row|
              columns = columns +', ' + row.values.to_s
            end
            csv << [columns]
            textbooklevelarr.each do |row|
              csv << row.values
            end
          end

          end
      end
      return csvfilename
    end
=end

    # Text book level csv download
    def nontextbook_level_download(originid)
      csvfilename= 'non_textbook_coverage_rpt.csv'     
     
      tlevelarr = ReadLevel.select('id,name')     
      categoryarr = Category.where("id")
      #categoryarr = Category.where("id<>?",3)
     
        CSV.open(Rails.root.to_s+"/csvdownload/"+csvfilename, "wb") do |csv|
            if originid.to_s=="-2"
             
              categoryarr.each do |category|
                if Book.where("category_id=?",category.id).count >0
                  headingname = " > Category :"+ category.name rescue nil
                  csv << [headingname]
                  subcategoryarr = Subcategory.where("category_id=?",category.id)
                  subcategoryheaarr = subcategoryarr.map {|subj| subj.name}
           
                      # Subject Header row
                      csv << [""]+subcategoryheaarr                       
                      # Add rows for textbook level
                         
                      tlevelarr.each do |tlevel|       
                        subcount_arr=[]                       
                        subcategoryarr.each do |subcatg| 
                        
                          countbook = Book.where("read_level_id=? && category_id=? && subcategory_id=?",tlevel.id,category.id,subcatg.id).count
                      
                          if countbook > 0
                               subcount_arr.push(countbook)
                          else
                            subcount_arr.push("No")
                          end        
                                     
                        end                   
                        csv << [tlevel.name]+subcount_arr   
                      end
                      csv << [""]
                      csv << [""]    
                end 
              end
              
            else
              
              if originid != 0 && originid != "All"        
                originsarr = Origin.where("id=?",originid)
              else        
                originsarr = Origin.find(:all)        
              end   
              originsarr.each do |origin|
                if Book.where("origin_id=?",origin.id).count >0
                  originname = origin.name rescue nil
                  csv << [originname]            
               
                  # Country row
                  categoryarr.each do |category|
                    if Book.where("origin_id=? && category_id=?",origin.id,category.id).count >0
                      headingname = " > Category :"+ category.name rescue nil
                      csv << [headingname]
                      subcategoryarr = Subcategory.where("category_id=?",category.id)
                      subcategoryheaarr = subcategoryarr.map {|subj| subj.name}
               
                          # Subject Header row
                          csv << [""]+subcategoryheaarr                       
                          # Add rows for textbook level
                             
                          tlevelarr.each do |tlevel|       
                            subcount_arr=[]                       
                            subcategoryarr.each do |subcatg| 
                            
                              countbook = Book.where("read_level_id=? && category_id=? && subcategory_id=? &&  origin_id=?",tlevel.id,category.id,subcatg.id, origin.id).count
                          
                              if countbook > 0
                                subcount_arr.push(countbook)
                              else
                                subcount_arr.push("No")
                              end        
                                         
                            end                   
                            csv << [tlevel.name]+subcount_arr   
                          end
                      csv << [""]
                      csv << [""] 
                    end                               
                  end
                end
              end        
            end
               
        end

     
      #check category end here
      return csvfilename
    end

     # Text book level csv download with language
    def nontextbook_level_download_lang(originid)
      csvfilename= 'non_textbook_coverage_rpt.csv'     
     
      tlevelarr = ReadLevel.select('id,name')
      langarr = Language.select('id,name')
      langgarr = langarr.map {|lang| lang.name}
      categoryarr = Category.where("id<>?",3)
     
        CSV.open(Rails.root.to_s+"/csvdownload/"+csvfilename, "wb") do |csv|
            if originid.to_s=="-2"
             
              categoryarr.each do |category|
                
                if Book.where("category_id=?",category.id).count >0
                  headingname = " > Category :"+ category.name rescue nil
                  csv << [headingname]
                  subcategoryarr = Subcategory.where("category_id=?",category.id)
                  subcategoryheaarr = subcategoryarr.map {|subj| subj.name}
               
                          # Subject Header row
                          # csv << [""]+subcategoryheaarr                       
                          # Add rows for textbook level
                             
                          subcategoryarr.each do |subcatg|                                 
                           
                            subheadingname = " >> Subcategory :"+ subcatg.name rescue nil
                            csv << [""]+[subheadingname]
                            csv << [""]+langgarr                    
                            tlevelarr.each do |tlevel| 
                             # if Book.where("read_level_id=? && origin_id=? && category_id=? && subcategory_id=?",tlevel.id,category.id,subcatg.id, origin.id).count >0   
                                subcount_arr=[]                               

                                langarr.each do |langrow| 
                                  countbook = Book.where("read_level_id=? && category_id=? && subcategory_id=? && language_id=?",tlevel.id,category.id,subcatg.id,langrow.id).count
                              
                                  if countbook > 0
                                    subcount_arr.push(countbook)
                                  else
                                    subcount_arr.push("No")
                                  end 
                                end #language loop
                              # end # check count   
                              csv << [tlevel.name]+subcount_arr
                            end # level loop                  
                                 
                          end # subcategory arr
                      csv << [""]
                      csv << [""]    
                end 
              end
              
            else
              
              if originid != 0 && originid != "All"        
                originsarr = Origin.where("id=?",originid)
              else        
                originsarr = Origin.find(:all)        
              end   
              originsarr.each do |origin|
                if Book.where("origin_id=?",origin.id).count >0
                  originname = origin.name rescue nil
                  csv << [originname]            
               
                  # Country row
                  categoryarr.each do |category|
                    if Book.where("origin_id=? && category_id=?",origin.id,category.id).count >0
                      headingname = " > Category :"+ category.name rescue nil
                      csv << [headingname]
                      subcategoryarr = Subcategory.where("category_id=?",category.id)
                      subcategoryheaarr = subcategoryarr.map {|subj| subj.name}
               
                          # Subject Header row
                          # csv << [""]+subcategoryheaarr                       
                          # Add rows for textbook level
                             
                          subcategoryarr.each do |subcatg|                                 
                           
                            subheadingname = " >> Subcategory :"+ subcatg.name rescue nil
                            csv << [""]+[subheadingname]
                            csv << [""]+langgarr                    
                            tlevelarr.each do |tlevel| 
                             # if Book.where("read_level_id=? && origin_id=? && category_id=? && subcategory_id=?",tlevel.id,category.id,subcatg.id, origin.id).count >0   
                                 subcount_arr=[]
                               

                                langarr.each do |langrow| 
                                  countbook = Book.where("read_level_id=? && category_id=? && subcategory_id=? &&  origin_id=? && language_id=?",tlevel.id,category.id,subcatg.id, origin.id,langrow.id).count
                              
                                  if countbook > 0
                                    subcount_arr.push(countbook)
                                  else
                                    subcount_arr.push("No")
                                  end 
                                end #language loop
                              # end # check count   
                              csv << [tlevel.name]+subcount_arr
                            end # level loop                  
                                 
                          end # subcategory arr
                      csv << [""]
                      csv << [""] 
                    end                               
                  end
                end
              end        
            end               
        end     
      #check category end here
      return csvfilename
    end





    # def book_pushed_download(startdate,enddate)

    #   csvfilename= 'book_pushed_file.csv'
    #   pricingmodel =""
    #   # bookarr = Book.select("distinct books.*,publishers.name as pubname,count(devices.account_id) as copies,GROUP_CONCAT(distinct purchase_order_id) as group_purchaseorderid,projects.name as proj_name").joins(:publisher,:devices).where("projects.project_type_id=? && (pushes.push_date>=? && pushes.push_date<=?)",1,startdate,enddate).group("pushes.book_id").order("projects.name")
    #   bookarr = Book.select("distinct books.*,publishers.name as pubname,count(devices.account_id) as copies,GROUP_CONCAT(distinct purchase_order_id) as group_purchaseorderid,projects.name as proj_name").joins(:publisher,:devices).where("projects.project_type_id=? && (pushes.push_date>=? && pushes.push_date<=?)",1,startdate,enddate).order("projects.name")
      
    #   CSV.open(Rails.root.to_s+"/csvdownload/"+csvfilename, "wb") do |csv|
    #     csv << ["ASIN","Publisher","Title","Copies","Free"]
    #     projectname=""
    #     bookarr.each do |bookpushed|
    #       pricingm = ""
    #       wherestring ="purchase_order_id in ("+bookpushed.group_purchaseorderid+")"
    #       totaldevices = Device.select("count(devices.account_id) as copies").where(wherestring)
          
    #       if bookpushed.proj_name != projectname
    #         projectname=bookpushed.proj_name
    #         csv << [""]
    #         csv << [bookpushed.proj_name]
    #         csv << [""]
    #       end 

    #       if bookpushed.free=="free"
    #         pricingm = "True"
    #       else
    #           if bookpushed.free=="paid"
    #             pricingm = "False"
    #           end
    #       end
    #       csv << [bookpushed.asin,bookpushed.pubname,bookpushed.title,(totaldevices[0]["copies"]).to_s,pricingm]
    #     end
    #   end

    #   return csvfilename      
    # end


    def book_pushed_download(startdate,enddate)

      csvfilename= 'book_pushed_file.csv'
      booksdata = Book.select("distinct books.*,publishers.name as pubname,publishers.free,GROUP_CONCAT(distinct purchase_order_id) as group_purchaseorderid,projects.name as proj_name").joins(:publisher,:devices).where("projects.project_type_id=? && (pushes.push_date>=? && pushes.push_date<=?)",1,startdate,enddate).group("content_buckets.id,pushes.book_id").order("projects.name")
     
      CSV.open(Rails.root.to_s+"/csvdownload/"+csvfilename, "wb") do |csv|
          csv << ["ASIN","Publisher","Title","Copies","Free"]      
          projectname=""
          booksdata.each do |bookpushed|
          pricingm = ""
          wherestring ="purchase_order_id in ("+bookpushed.group_purchaseorderid+")"
          totaldevices = Device.select("count(devices.account_id) as copies").where(wherestring)
          

            if bookpushed.proj_name != projectname
              projectname=bookpushed.proj_name
              csv << [""]
              csv << [bookpushed.proj_name]
              csv << [""]
            end 

            if bookpushed.free=="free"
              pricingm = "True"
            else
                if bookpushed.free=="paid"
                  pricingm = "False"
                end
            end
            csv << [bookpushed.asin,bookpushed.pubname,bookpushed.title,(totaldevices[0]["copies"]).to_s,pricingm]
          end
      end

      return csvfilename      
    end

    # Book Coverage Report
    def coverage_download()    
      csvfilename= 'coverage_file.csv'       

        CSV.open(Rails.root.to_s+"/csvdownload/"+csvfilename, "wb") do |csv|         
          time = Time.new        
          reporttime = time.strftime("%b %d, %Y")
          csv << ["Report : " + reporttime]
          csv << ["Overview"]
          
          # All Content (By Pricing Model/Status)          
          bookstatuses = BookStatus.select('id,name').where("name<>?","na")          
          #bookstatuses = BookStatus.select('id,name').order("name").where("name<>?","na")          
          total_all_arr=[]
          total_free_arr=[]
          total_paid_arr=[]
          statuses_arr =bookstatuses.map { |statuses| statuses.name}

          csv << ["All Content (By Pricing Model/Status)",""] + statuses_arr
          bookstatuses.each do |bookst|
            total_all_arr.push(Book.joins(:book_status).where("book_statuses.name=?",bookst.name).count)
            total_free_arr.push(Book.joins(:book_status,:publisher).where("book_statuses.name=? and publishers.free=?",bookst.name,"free").count)
            total_paid_arr.push(Book.joins(:book_status,:publisher).where("book_statuses.name=? and publishers.free=?",bookst.name,"paid").count)
          end        
          csv << ["","ALL"] + total_all_arr
          csv << ["","Donated"] + total_free_arr
          csv << ["","Paid Content"] + total_paid_arr
          
          # Add 2 Blank rows
          csv << [""]
          csv << [""]


          # All Content (By Language Sum/Level)
          levels = ReadLevel.select('id,name').order("name")
          levels_all = ReadLevel.select('id,name').order("name")
          language = Language.select('id,name').order("name")
          levels_all_arr=[]
          levels_english_arr=[]
          levels_textbooks_arr=[]
          levels_study_arr=[]
          levels_oth_lang_arr=[]

          levels_arr =levels.map { |level| level.name}
          levels_all_val_sum = 0
          levels_eng_val_sum = 0
          levels_other_val_sum = 0
	  levels_textbooks_all = 0
          csv << ["All Content (By Language Sum/Level)","","Beginning Readers","","Literary Works + NonFiction"]
          csv << ["",""] + levels_arr + ["Total (Readers)", "Textbooks + Teacher's Guides", "Reference + Study Aids","Total"]

	  levels_all.each do |alllevel|
		levels_all_arr.push(Book.joins(:read_level,:category).where("books.read_level_id = ?",alllevel.id).count)
	  end

          csv << ["","ALL"] + levels_all_arr + [levels_all_arr.sum] + [Book.joins(:category).where("categories.name=?","Textbooks and Teachers Guides").count] + [Book.joins(:category).where(" (categories.name=? or categories.name=? )","Reference","Study Aids").count] + [levels_all_arr.sum + Book.joins(:category).where("categories.name=?","Textbooks and Teachers Guides").count + Book.joins(:category).where(" (categories.name=? or categories.name=? )","Reference","Study Aids").count]
          #csv << ["","ALL"] + levels_all_arr + [levels_all_val_sum] + [Book.joins(:category).where("categories.name=?","Textbooks and Teachers Guides").count] + [Book.joins(:category).where(" (categories.name=? or categories.name=? )","Reference","Study Aids").count] + [levels_all_val_sum + Book.joins(:category).where("categories.name=?","Textbooks and Teachers Guides").count + Book.joins(:category).where(" (categories.name=? or categories.name=? )","Reference","Study Aids").count]

	language.each do  |langlevel|

          levels.each do |rlevel|           

            if rlevel.name=="A" || rlevel.name=="B"
             
              #levels_all_arr.push(Book.joins(:read_level,:category).where("books.read_level_id = ? and categories.name=?",rlevel.id,"Beginning Readers").count)
             
		levels_english_arr.push(Book.joins(:read_level,:category,:language).where("read_level_id = ? and categories.name=? and languages.name=?",rlevel.id,"Beginning Readers",langlevel.name).count)

             
            else 
                if rlevel.name=="C" || rlevel.name=="D" || rlevel.name=="E" || rlevel.name=="F" || rlevel.name=="G"
             
                #  levels_all_arr.push(Book.joins(:read_level,:category,:textbook_subject).where("read_level_id = ? and (categories.name=? or categories.name=?)",rlevel.id,"Nonfiction","Literary Works").count)
             
                  levels_english_arr.push(Book.joins(:read_level,:category,:language).where("read_level_id = ? and languages.name = ? and (categories.name=? or categories.name=?)",rlevel.id,langlevel.name,"Nonfiction","Literary Works").count)
                  #levels_english_arr.push(Book.joins(:read_level,:category,:textbook_subject,:language).where("read_level_id = ? and textbook_subject_id=? and languages.name = ? and (categories.name=? or categories.name=?)",rlevel.id,8,langlevel.name,"Nonfiction","Literary Works").count)
             
                  #levels_oth_lang_arr.push(Book.joins(:read_level,:category,:textbook_subject).where("read_level_id = ? and textbook_subject_id<>? and (categories.name=? or categories.name=?)",rlevel.id,8,"Nonfiction","Literary Works").count)
             
                else              
             
                  levels_all_arr.push(Book.joins(:read_level,:textbook_subject).where("read_level_id = ?",rlevel.id).count)
             
                  levels_english_arr.push(Book.joins(:read_level,:textbook_subject).where("read_level_id = ? and textbook_subject_id=?",rlevel.id,8).count)
             
                  levels_oth_lang_arr.push(Book.joins(:read_level,:textbook_subject).where("read_level_id = ? and textbook_subject_id<>?",rlevel.id,8).count)
                end
            end                     

          end  

	levels_study_arr.push(Book.joins(:category,:textbook_subject,:language).where("categories.name=? or categories.name=? and languages.name = ?","Reference","Study Aids",langlevel.name).count)
	levels_textbooks_arr.push(Book.joins(:category,:textbook_subject,:language).where("categories.name=?  and languages.name = ?","Textbooks and Teachers Guides",langlevel.name).count)

	levels_textbooks_all = levels_textbooks_arr.sum + levels_study_arr.sum + levels_english_arr.sum


          csv << ["",langlevel.name] + levels_english_arr + [levels_english_arr.sum] + [levels_textbooks_arr.sum] + [levels_study_arr.sum] + [levels_textbooks_all]

	levels_english_arr=[]
        levels_all_val_sum = 0
        levels_eng_val_sum = 0
        levels_other_val_sum = 0
        levels_textbooks_arr = []
        levels_study_arr = []
        levels_textbooks_all = 0

	end

          # Sum of array value
          levels_all_val_sum = levels_all_arr.map{ |r| r }.inject(:+)        
          levels_eng_val_sum = levels_english_arr.map{ |r| r }.inject(:+)
          levels_other_val_sum = levels_oth_lang_arr.map{ |r| r }.inject(:+)


#          csv << ["","ALL"] + levels_all_arr + [levels_all_val_sum] + [Book.joins(:category).where("categories.name=?","Textbooks and Teachers Guides").count] + [Book.joins(:category).where(" (categories.name=? or categories.name=? )","Reference","Study Aids").count] + [levels_all_val_sum + Book.joins(:category).where("categories.name=?","Textbooks and Teachers Guides").count + Book.joins(:category).where(" (categories.name=? or categories.name=? )","Reference","Study Aids").count]
          #csv << ["","English (Total)"] + levels_english_arr + [levels_eng_val_sum] +  [Book.joins(:category,:textbook_subject).where("categories.name=? and textbook_subject_id=?","Textbooks and Teachers Guides",8).count] + [Book.joins(:category,:textbook_subject).where(" (categories.name=? or categories.name=? ) and textbook_subject_id=?","Reference","Study Aids",8).count] +[levels_eng_val_sum +  Book.joins(:category,:textbook_subject).where("categories.name=? and textbook_subject_id=?","Textbooks and Teachers Guides",8).count + Book.joins(:category,:textbook_subject).where(" (categories.name=? or categories.name=? ) and textbook_subject_id=?","Reference","Study Aids",8).count]
          # csv << ["","Other Languages (Total)"] + levels_oth_lang_arr + [levels_other_val_sum] + [Book.joins(:category,:textbook_subject).where("categories.name=? and textbook_subject_id=?","Textbooks and Teachers Guides",8).count] + [Book.joins(:category,:textbook_subject).where(" (categories.name=? or categories.name=? ) and textbook_subject_id<>?","Reference","Study Aids",8).count] +[levels_other_val_sum + Book.joins(:category,:textbook_subject).where("categories.name=? and textbook_subject_id=?","Textbooks and Teachers Guides",8).count + Book.joins(:category,:textbook_subject).where(" (categories.name=? or categories.name=? ) and textbook_subject_id<>?","Reference","Study Aids",8).count]
          
          # Add 2 Blank rows
          csv << [""]
          csv << [""]

          # Donated Content (By Language/Level)          
          levels = ReadLevel.select('id,name').order("name")
          # subjectstr = ["English","Twi (Akuapem)",""]
          textbooksubjects = TextbookSubject.select('id,name').order("name")
         
          levels_arr = levels.map { |level| level.name }       
          csv << ["Donated Content (By Language/Level) "]
          csv << ["",""] + levels_arr + ["Total (Readers)", "Textbooks + Teacher's Guides", "Reference + Study Aids","Total"]
          dlanguage_total = 0
          dlanguage_t=0
	  dtextbooks_arr=[]
	  dstudy_arr=[]
          alltotal_d =0 
          total_col = 0

	    language.each do |langlevel|
          #textbooksubjects.each do |subject|
            bookdata_arr = []
            levels.each do |rlevel|
              bookdata_arr.push(Book.joins(:publisher,:read_level,:language).where("publishers.free=? and read_level_id = ? and languages.name=?","free",rlevel.id,langlevel.name).count)              
            end

	   dtextbooks_arr.push(Book.joins(:publisher,:category,:language).where("publishers.free=? and categories.name=? and languages.name=? ","free","Textbooks and Teachers Guides",langlevel.name).count)
	   dstudy_arr.push(Book.joins(:publisher,:category,:language).where("publishers.free=? and (categories.name=? or categories.name=?)  and languages.name=?","free","Reference","Study Aids",langlevel.name).count)
	
	   dlanguage_total = dtextbooks_arr.sum + dstudy_arr.sum + bookdata_arr.sum
			
            csv << ["",langlevel.name]+bookdata_arr+[bookdata_arr.sum]+ [dtextbooks_arr.sum] + [dstudy_arr.sum] + [dlanguage_total]
            #csv << ["",langlevel.name]+bookdata_arr+[bookdata_arr.sum]+[Book.joins(:publisher,:category,).where("publishers.free=? and categories.name=? ","free","Textbooks and Teachers Guides").count] + [Book.joins(:publisher,:category,).where("publishers.free=? and (categories.name=? or categories.name=?) ","free","Reference","Study Aids").count] + [dlanguage_total=Book.joins(:publisher,:category,).where("publishers.free=? and categories.name=? ","free","Textbooks and Teachers Guides").count + Book.joins(:publisher,:category,).where("publishers.free=? and (categories.name=? or categories.name=?) ","free","Reference","Study Aids").count ]
   alltotal_d = dlanguage_total + alltotal_d

          dtextbooks_arr=[]
          dstudy_arr=[]
          dtextbook_all=0


            #csv << ["",langlevel.name]+bookdata_arr+[dlanguage_t]+[Book.joins(:publisher,:category,).where("publishers.free=? and categories.name=? ","free","Textbooks and Teachers Guides").count] + [Book.joins(:publisher,:category,).where("publishers.free=? and (categories.name=? or categories.name=?) ","free","Reference","Study Aids").count] + [dlanguage_total]
          end
            #csv << ["",langlevel.name]+bookdata_arr+[dlanguage_t]+[Book.joins(:publisher,:category,:textbook_subject).where("publishers.free=? and categories.name=? and textbook_subject_id=?","free","Textbooks and Teachers Guides",subject.id).count] + [Book.joins(:publisher,:category,:textbook_subject).where("publishers.free=? and (categories.name=? or categories.name=?) and textbook_subject_id=?","free","Reference","Study Aids",subject.id).count] + [dlanguage_total]
	   # end
            # Sum of array value
            #dlanguage_t=dlanguage_total = bookdata_arr.map{ |r| r }.inject(:+)            
          
            #total_col =Book.joins(:publisher,:category,:textbook_subject).where("publishers.free=? and categories.name=? and textbook_subject_id=?","free","Beginning Readers",subject.id).count + Book.joins(:publisher,:category,:textbook_subject).where("publishers.free=? and categories.name=? and textbook_subject_id=?","free","Textbooks and Teachers Guides",subject.id).count + Book.joins(:publisher,:category,:textbook_subject).where(" publishers.free=? and (categories.name=? or categories.name=?) and textbook_subject_id=?","free","Reference","Study Aids",subject.id).count
            #dlanguage_total = dlanguage_total + total_col
            #alltotal_d =  dlanguage_total + alltotal_d
            #csv << ["",subject.name]+bookdata_arr+[dlanguage_t]+[Book.joins(:publisher,:category,:textbook_subject).where("publishers.free=? and categories.name=? and textbook_subject_id=?","free","Textbooks and Teachers Guides",subject.id).count] + [Book.joins(:publisher,:category,:textbook_subject).where("publishers.free=? and (categories.name=? or categories.name=?) and textbook_subject_id=?","free","Reference","Study Aids",subject.id).count] + [dlanguage_total]

          # Add 2 Blank rows        
          csv << ["","","","","","","","","","","","All language : ", alltotal_d]
          csv << [""]


          # Paid Content (By Language/Level)          
          levels = ReadLevel.select('id,name').order("name")
          textbooksubjects = TextbookSubject.select('id,name').order("name")
         
          levels_arr = levels.map { |level| level.name }       
          csv << ["Paid Content (By Language/Level)"]
          csv << ["",""] + levels_arr + ["Total (Readers)", "Textbooks + Teacher's Guides", "Reference + Study Aids","Total"]
          ptotal_col = 0
          alltotal = 0
          planguage_total = 0
	  ptextbook_arr=[]
	  pstudy_arr=[]
	  
          plang_t=0
            language.each do |langlevel|
          #textbooksubjects.each do |subject|
            bookdata_arr = []
            levels.each do |rlevel|
              bookdata_arr.push(Book.joins(:publisher,:read_level,:language).where("publishers.free=? and read_level_id = ? and languages.name = ? ","paid",rlevel.id,langlevel.name).count)              
            end
             # Sum of array value
          # plang_t= planguage_total = bookdata_arr.map{ |r| r }.inject(:+) 
          #  ptotal_col = Book.joins(:publisher,:category,:textbook_subject).where("publishers.free=? and categories.name=? and textbook_subject_id=?","paid","Textbooks and Teachers Guides",subject.id).count + Book.joins(:publisher,:category,:textbook_subject).where(" publishers.free=? and (categories.name=? or categories.name=?) and textbook_subject_id=?","paid","Reference","Study Aids",subject.id).count
          #  planguage_total = planguage_total + ptotal_col
          #  alltotal = planguage_total + alltotal

	ptextbook_arr.push(Book.joins(:publisher,:category,:language).where("publishers.free=? and categories.name=? and languages.name = ?","paid","Textbooks and Teachers Guides",langlevel.name).count)
	pstudy_arr.push(Book.joins(:publisher,:category,:language).where("publishers.free=? and (categories.name=? or categories.name=?)and languages.name = ? ","paid","Reference","Study Aids",langlevel.name).count)	

	planguage_total = ptextbook_arr.sum + pstudy_arr.sum + bookdata_arr.sum

            csv << ["",langlevel.name]+bookdata_arr+[bookdata_arr.sum]+[ptextbook_arr.sum] + [pstudy_arr.sum] + [planguage_total] 
            #csv << ["",langlevel.name]+bookdata_arr+[bookdata_arr.sum]+[Book.joins(:publisher,:category).where("publishers.free=? and categories.name=? ","paid","Textbooks and Teachers Guides").count] + [Book.joins(:publisher,:category).where("publishers.free=? and (categories.name=? or categories.name=?) ","paid","Reference","Study Aids").count] +[ planguage_total =Book.joins(:publisher,:category).where("publishers.free=? and categories.name=? ","paid","Textbooks and Teachers Guides").count + Book.joins(:publisher,:category).where("publishers.free=? and (categories.name=? or categories.name=?) ","paid","Reference","Study Aids").count] 
	  alltotal = planguage_total + alltotal

	  pstudy_arr=[]
	  planguage_total=0
	  ptextbook_arr=[]

          end
          # Add 2 Blank rows
          csv << ["","","","","","","","","","","","All language : ", alltotal]
          csv << [""]
          
          
          # Paid Content (By Continent: Country/Category)
          categoryheadlist = Category.select('id,name').where("id<>?",3).order("name")
          categorylist = Category.select('id,name').order("name")
          continentlist = Continent.select('id,name').order("name")
         
          category_arr = categoryheadlist.map { |category| category.name }       
          csv << ["Paid Content (By Continent: Country/Category)" ,"","","","","","","", "Textbooks + Teacher's Guides"]
          csv << ["","",""] + category_arr + ["Textbooks","Teacher's Guides","Total"]
          contientid = 0

          # Continents loop
          continentlist.each do |continentitem|
            
            originlist = Origin.select('id,name').where("continent_id=?",continentitem.id).order("name")
            
            # Origin loop
            originlist.each do |ogiginitem|
              totalbooks = []
              booksinrrow = 0
              totalbooksinarr = 0
              # Category loop
              categoryheadlist.each do |catryitem|
                booksinrrow = Book.joins(:publisher,:category,:origin).where("publishers.free=? and books.category_id=? and books.origin_id=?","paid",catryitem.id,ogiginitem.id).count
                totalbooks.push(booksinrrow)
                totalbooksinarr  = totalbooksinarr + booksinrrow
              end

              # Get count for textbooks and textbook guides subcategories.
              textbookSubcount = Book.joins(:publisher,:category,:subcategory,:origin).where("publishers.free=? and subcategories.category_id=? and books.origin_id=? and subcategories.id=?","paid",3,ogiginitem.id,18).count
              textbookGuideSubcount = Book.joins(:publisher,:category,:subcategory,:origin).where("publishers.free=? and subcategories.category_id=? and books.origin_id=? and subcategories.id=?","paid",3,ogiginitem.id,17).count

              if contientid != continentitem.id
                  contientid = continentitem.id
                  csv << ["",continentitem.name,ogiginitem.name]+ totalbooks + [textbookSubcount,textbookGuideSubcount,totalbooksinarr+textbookSubcount+textbookGuideSubcount]
              else
                  csv << ["","",ogiginitem.name]+ totalbooks + [textbookSubcount,textbookGuideSubcount,totalbooksinarr+textbookSubcount+textbookGuideSubcount]
              end


            end
          end

          
          # All Content (By Subcategory)          
          sub_category_list = Subcategory.select('id,name').order("name")          
         
          subcat_arr = sub_category_list.map {|subcat| subcat.name}

          csv << ["All Content (By Subcategory)"]
        
          
          sub_category_list.each do |subcat_books|           
            csv << ["",subcat_books.name] +  [Book.where("subcategory_id=?",subcat_books.id).count]
          end
          csv << [""]
          csv << ["","*Uncategorized"] +  [Book.where("subcategory_id <> '' AND subcategory_id IS NOT NULL").count]
          

        end
      return csvfilename
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
                value = 0 # "---ERROR---"
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
      abort("old csv");
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

  def convert_kdp_data(csv_data, start_date, end_date)
    
    #abort(start_date);

    csv_file = csv_data.read # this returns an array of arrays ["Europe"]["USA"][...]
      CSV.parse(csv_file) do |row|
          # we need to insert
            reportkdp = KdpReport.new
            reportkdp.start_date = start_date
            reportkdp.end_date = end_date     

              
            reportkdp.asin = row[0]
            reportkdp.month_sold = row[1]
            reportkdp.transaction_type = row[4]
            reportkdp.net_units_sold_or_borrowed = row[5]
            @check6 = row[6].to_s
        
            if @check6.numeric? == true
                reportkdp.average_delivery_cost = row[6]
            end
            
            reportkdp.royalty = row[7]
            reportkdp.store = row[8]
            reportkdp.currency = row[9]
            reportkdp.exchange_rate = row[10]
            reportkdp.usd_net = row[11]
            reportkdp.owed_to_publisher = row[12]

          
            if Book.where("asin like ?", reportkdp.asin).count()>0
              row[13] = Book.where("asin like ?", reportkdp.asin)[0]['id'] 
            else
              #print "Oops! No Record found for" + row[12].to_s() + "\n"
              row[13] = ""
            end
            reportkdp.book_id = row[13]   
     
          #  newbook.binu_source_file_name = row[0]
            #abort(newbook.errors.to_s()) 
            #
           # @messages={:publisher_id=>["can't be blank"], :language_id=>["can't be blank"], :book_status_id=>["can't be blank"]}>

            reportkdp.save
      end


  end



  def convert_save_books_mobile(csv_data)

    # Step 1 : Loop Upload data
      # Step 2 :  Match the title to see if there is an exact match available. 
      # Step 3 : If there is an exact title Match Update the information. 
      # Step 4 : Insert an new record with the matching title and proceed with it. 

      csv_file = csv_data.read # this returns an array of arrays ["Europe"]["USA"][...]
      i=0;
      CSV.parse(csv_file) do |row|
      if i==0
        i=1
        next
      end 

        booktitle = row[2]

        if Book.where("title like ?",booktitle).count()>0
            # we need to update  
              
          updatebook = Book.where("title like ?",booktitle)[0];
       
			
			    updatebook.binu_paperback_equivalent =row[1]
    			updatebook.binu_source_file_name =row[0]
    			updatebook.binu_sort_title =row[3]
    			updatebook.binu_series =row[4]
    			updatebook.binu_creator_1_name =row[5]
    			updatebook.binu_creator_1_role =row[6]
    			updatebook.binu_publisher =row[7]
    			updatebook.binu_imprint =row[8]
    			updatebook.binu_pub_date =row[9]
    			updatebook.binu_srp_inc_vat =row[10]
    			updatebook.binu_currency =row[11]
    			updatebook.binu_on_sale_date =row[12]
    			updatebook.binu_langauge =row[13]
    			updatebook.binu_geo_rights =row[14]
    			updatebook.binu_subject1 =row[15]
    			updatebook.binu_subject2 =row[16]
    			updatebook.binu_bisac =row[17]
    			updatebook.binu_bic =row[18]
    			updatebook.binu_bic2 =row[19]
    			updatebook.binu_fiction_subject2 =row[20]
    			updatebook.binu_keyword =row[21]
    			updatebook.binu_short_description =row[22]
    			updatebook.binu_not_for_sale =row[23]
    			updatebook.binu_ready_for_sale =row[24]
    			updatebook.binu_country =row[25]
    			updatebook.save
		   
		      # updatebook.binu_source_file_name = row[0]
           # abort(updatebook.errors.to_s()) 
          
        else
              

       
            # we need to insert
            newbook = Book.new
     
            newbook.asin="NULL"
            newbook.title=row[2]
            newbook.price="NULL"
            newbook.rating="NULL"
            newbook.flagged=0
            newbook.copublished="NULL"
            newbook.publisher_id="NULL"
            newbook.language_id="NULL"
            newbook.genre_id="NULL"
            newbook.description="NULL"
            newbook.created_at="NULL"
            newbook.updated_at="NULL"
            newbook.date_added="NULL"
            newbook.restricted="NULL"
            newbook.limited="NULL"
            newbook.fiction_type_id="NULL"
            newbook.textbook_level_id="NULL"
            newbook.textbook_subject_id="NULL"
            newbook.book_status_id="NULL"
            newbook.source_file="NULL"
            newbook.source_cover="NULL"
            newbook.mobi="NULL"
            newbook.epub="NULL"
            newbook.fixed_epub="NULL"
            newbook.comments="NULL"
            newbook.mou_fname="NULL"
            newbook.origin_id="NULL"
            newbook.appstatus_id="NULL"
            newbook.appstatus="NULL"
            newbook.keywords="NULL"
            newbook.read_level_id="NULL"
            newbook.textbook_sumlevel_id="NULL"
            newbook.category_id="NULL"
            newbook.subcategory_id="NULL"
            newbook.binu_source_file_name=row[0]
            newbook.binu_paperback_equivalent=row[1]
            newbook.binu_sort_title=row[3]
            newbook.binu_series=row[4]
            newbook.binu_creator_1_name=row[5]
            newbook.binu_creator_1_role=row[6]
            newbook.binu_publisher=row[7]
            newbook.binu_imprint=row[8]
            newbook.binu_pub_date=row[9]
            newbook.binu_srp_inc_vat=row[10]
            newbook.binu_currency=row[11]
            newbook.binu_on_sale_date=row[12]
            newbook.binu_langauge=row[13]
            newbook.binu_geo_rights=row[14]
            newbook.binu_subject1=row[15]
            newbook.binu_subject2=row[16]
            newbook.binu_bisac=row[17]
            newbook.binu_bic=row[18]
            newbook.binu_bic2=row[19]
            newbook.binu_fiction_subject2=row[20]
            newbook.binu_keyword=row[21]
            newbook.binu_short_description=row[21]
            newbook.binu_not_for_sale=row[22]
            newbook.binu_ready_for_sale=row[23]
            newbook.binu_country=row[25]
            newbook.certified_by_national_board_of_education="NULL"
            newbook.book_id="NULL"
            newbook.geo_restricted="NULL"
            newbook.geo_restrictedby="NULL"
            newbook.textguide_book_id="NULL"
            

          
            # newbook.title = row[2]
            # newbook.publisher_id = 'null'
            # newbook.language_id = 'null'
            # newbook.book_status_id = 'null'
            # newbook.asin = "null"
            # newbook.pricingmodel="null"
            # newbook.binu_paperback_equivalent =row[1]
            # newbook.binu_source_file_name =row[0]
            # newbook.binu_sort_title =row[3]
            # newbook.binu_series =row[4]
            # newbook.binu_creator_1_name =row[5]
            # newbook.binu_creator_1_role =row[6]
            # newbook.binu_publisher =row[7]
            # newbook.binu_imprint =row[8]
            # newbook.binu_pub_date =row[9]
            # newbook.binu_srp_inc_vat =row[10]
            # newbook.binu_currency =row[11]
            # newbook.binu_on_sale_date =row[12]
            # newbook.binu_langauge =row[13]
            # newbook.binu_geo_rights =row[14]
            # newbook.binu_subject1 =row[15]
            # newbook.binu_subject2 =row[16]
            # newbook.binu_bisac =row[17]
            # newbook.binu_bic =row[18]
            # newbook.binu_bic2 =row[19]
            # newbook.binu_fiction_subject2 =row[20]
            # newbook.binu_keyword =row[21]
            # newbook.binu_short_description =row[22]
            # newbook.binu_not_for_sale =row[23]
            # newbook.binu_ready_for_sale =row[24]
            # newbook.binu_country =row[25]
          
           
            newbook.save
 # abort(newbook.errors.to_s())
            

          end
      
      end # CSV do row loop ends here


  end


  def convert_save_books_new(csv_data)
      # Flow of the Import Process. 
      # Step 1 : Conver the CSV File into an array. 
      # Step 2 : Iterate for Each Row in the Array. 
      # Step 3 : Make an Insert Array
      # Step 3 : a) Make the Language into Language ID. 
      # Step 3 : b) Make the Publisher to PUblisher ID
      # Step 3 : c) 
    
      csv_file = csv_data.read # this returns an array of arrays ["Europe"]["USA"][...]
     # print csv_file.inspect
      # Checking the Looping of the data. 
       CSV.parse(csv_file) do |row|
          # We need to convert the data from the CSV 
          # to their relation ID
         #1 Conversion of : Language
          langname = row[12]
        
          if Language.where("name like ?",langname).count()>0
            row[12] = Language.where("name like ?",langname)[0]['id'] 
          else
            #print "Oops! No Record found for" + row[12].to_s() + "\n"
            row[12] = ""
          end
          
          #2 Conversion of : Genre

            # Please Note there is not field for Genre

          #3 Conversion of : fiction_type
            
            # Not found in the table. 

          #4 Conversion of : Categories
          langname = row[7]
          if Category.where("name like ?",langname).count()>0
            row[7] = Category.where("name like ?",langname)[0]['id'] 
          else
            #print "Oops! No Record found for" + row[12].to_s() + "\n"
            row[7] = ""
          end

          #5 Conversion of : subcategory
           langname = row[8]
             if Subcategory.where("name like ?",langname).count()>0
            row[8] = Subcategory.where("name like ?",langname)[0]['id'] 
          else
            #print "Oops! No Record found for" + row[12].to_s() + "\n"
            row[8] = ""
          end
          #6 Conversion of : textbook_level
           langname = row[9]
          if TextbookLevel.where("name like ?",langname).count()>0
            row[9] = TextbookLevel.where("name like ?",langname)[0]['id'] 
          else
            #print "Oops! No Record found for" + row[12].to_s() + "\n"
            row[9] = ""
          end

          #7 Conversion of : textbook_sumlevel
          #9 Conversion of : textbook_subject
           langname = row[10]
          if TextbookSubject.where("name like ?",langname).count()>0
            row[10] = TextbookSubject.where("name like ?",langname)[0]['id'] 
          else
            row[10] = ""
          end

          #10 Conversion of : book_status

          langname = row[0]
          if BookStatus.where("name like ?",langname).count()>0
            row[0] = BookStatus.where("name like ?",langname)[0]['id'] 
          else

            row[0] = ""
          end

          #11 Conversion of : publisher
           langname = row[5]
          if Publisher.where("name like ?",langname).count()>0
            row[5] = Publisher.where("name like ?",langname)[0]['id'] 
          else
            #print "Oops! No Record found for" + row[12].to_s() + "\n"
            row[5] = ""
          end

          #12 Conversion of : origin or Country
           langname = row[6]
          if Origin.where("name like ?",langname).count()>0
            row[6] = Origin.where("name like ?",langname)[0]['id'] 
          else
            #print "Oops! No Record found for" + row[12].to_s() + "\n"
            row[6] = ""
          end

          #13 Conversion of : read_level
           langname = row[11]
          if ReadLevel.where("name like ?",langname).count()>0
            row[11] = ReadLevel.where("name like ?",langname)[0]['id'] 
          else
            #print "Oops! No Record found for" + row[12].to_s() + "\n"
            row[11] = ""
          end

       #print "\n \n converted:"+row.to_s()+"\n"

       # Converting the Authors starts here. 
        row[4] = Author.find_or_create_by_name(:name=>row[4],:origin_id=>'null', :comments=>'null')['id']

         # Inserting the data into the database starts here. 

        newbook = Book.new
        newbook.asin = row[2]
        newbook.title = row[3]
        newbook.author_ids = row[4]
        #book.rating
        #book.price
        #book.flagged
        #book.copublished
        newbook.publisher_id = row[5]
        newbook.language_id= row[12]
        #book.genre_id
        newbook.description= row[14]
        #book.created_at
        #book.updated_at
        #book.date_added
        #book.restricted
        #book.limited
        #book.fiction_type_id
        newbook.textbook_level_id = row[9]
        #book.textbook_subject_id
        newbook.book_status_id =row[0]
        #book.source_file
        #book.source_cover
        #book.mobi
        #book.epub
        #book.fixed_epub
        #book.comments
        #book.mou_fname
        newbook.origin_id = row[6]
        #book.appstatus_id
        #book.appstatus
        #book.keywords
        newbook.read_level_id= row[11]
        #book.textbook_sumlevel_id
        newbook.category_id = row[7]
        newbook.subcategory_id = row[8]

        # Calling out the print status
        # print "\n----- shishir \n \n :"
        #abort(newbook.errors.to_s() )

        newbook.save
        # print "\n"

       end
        
  
      end  


  

  end
end

