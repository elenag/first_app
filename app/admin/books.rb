ActiveAdmin.register Book do

  batch_action :origins do |selection|
    Book.find(selection).each {|p| p.update_attribute(:origin_id, p.publisher.origin_id)}
    redirect_to collection_path, :notice => "country of origin changed!"
  end

  batch_action :in_store, :priority => 2 do |selection|
    Book.find(selection).each {|book| book.update_attribute(:in_store,'1')}
    redirect_to collection_path, :notice => "Selected books have been marked as AVAILABLE ON AMAZON STORE"
  end

  batch_action :not_in_store, :priority => 3 do |selection|
    Book.find(selection).each {|book| book.update_attribute(:in_store,'0')}
    redirect_to collection_path, :notice => "Selected books have been marked as NOT AVAILABLE ON AMAZON STORE"
  end

  #batch_action :destroy, false

    action_item :only => :index do
      link_to 'Upload books.csv', :action => 'upload_csv_new'
    end

    action_item :only => :index do
      link_to 'Upload Mobile Data .csv', :action => 'upload_csv_new_mobile'
    end
  

   collection_action :download_coverage_report do
      # @originarr=["All"]
      # @originarr=@originarr+Origin.all.map{ |origin| [origin.name, origin.id]}.sort
      render "admin/books/show_coverage_report"
   end
  

   collection_action :non_textbook_coverage_report do   
      @catin=[["All",""],["Composite All","-2"]]
      @originarr=@catin+Origin.all.map{ |origin| [origin.name, origin.id]}.sort
     
      @booleanoption2 = [['Textbook','textbook'],['Non-textbook','nontextbook'],['Both','both']]
      render "admin/books/show_nontextbook_level"
   end

  collection_action :textbook_coverage_report do
    @catin=[["All",""],["Composite All","-2"]]
    @originarr=@catin+Origin.all.map{ |origin| [origin.name, origin.id]}.sort

    @booleanoption2 = [['Textbook','textbook'],['Non-textbook','nontextbook'],['Both','both']]
    render "admin/books/show_textbook_level"
  end

   collection_action :download_books_per_kit do
      @catin=[["All",""],["Free","free"],["Paid","paid"]]    
        
      render "admin/books/download_book_pushed_render"
   end

    collection_action :download_book_pushed_rpt, :method => :post do
      @csvfilename = CsvDb.book_pushed_download(   
        Date.civil(
            params[:dump]['start_date(1i)'].to_i,
            params[:dump]['start_date(2i)'].to_i,
            params[:dump]['start_date(3i)'].to_i
        ).to_s,
        Date.civil(
            params[:dump]['end_date(1i)'].to_i,
            params[:dump]['end_date(2i)'].to_i,
            params[:dump]['end_date(3i)'].to_i
        ).to_s     
      )      
      send_file Rails.root.to_s+"/csvdownload/"+@csvfilename, :type => "application/csv"  
    end


   collection_action :download_coverage_rpt, :method => :post do
    
      @csvfilename = CsvDb.coverage_download(      
      
      # params[:dump]['origin'].to_i
    )
    
     send_file Rails.root.to_s+"/csvdownload/"+@csvfilename, :type => "application/csv"
   # redirect_to :action => :index, :notice => "KDP data write successfully!"
   end

   # 
    collection_action :download_nontextbook_level_rpt, :method => :post do
    
    if params[:dump]['textbook_withlanguage'].to_i==1
     
      @csvfilename = CsvDb.textbook_level_download_lang(      
        params[:dump]['origin'].to_i
        # params[:dump]['text_book_type'].to_s,
        # params[:dump]['textbook_categ'].to_s,
      )

    else
      @csvfilename = CsvDb.nontextbook_level_download(      
        params[:dump]['origin'].to_i
        # params[:dump]['text_book_type'].to_s,
        # params[:dump]['textbook_categ'].to_s,
      )
    end
     send_file Rails.root.to_s+"/csvdownload/"+@csvfilename, :type => "application/csv"
   # redirect_to :action => :index, :notice => "KDP data write successfully!"
   end


    collection_action :download_textbook_level_rpt, :method => :post do
   
    if params[:dump]['textbook_withlanguage'].to_i==1
    
      @csvfilename = CsvDb.textbook_level_download_lang(
        params[:dump]['origin'].to_i
        # params[:dump]['text_book_type'].to_s,
        # params[:dump]['textbook_categ'].to_s,
      )

    else
      @csvfilename = CsvDb.textbook_level_download(
        params[:dump]['origin'].to_i
        # params[:dump]['text_book_type'].to_s,
        # params[:dump]['textbook_categ'].to_s,
      )
    end
     send_file Rails.root.to_s+"/csvdownload/"+@csvfilename, :type => "application/csv"
   # redirect_to :action => :index, :notice => "KDP data write successfully!"
   end


    # action_item :only => :index do
    #   link_to 'Upload books.csv', :action => 'upload_csv'
    # end

    collection_action :upload_csv_new do
      render "admin/csv/upload_csv_new"
    end

      collection_action :upload_csv_new_mobile do
      render "admin/csv/upload_csv_mobile"
    end
    

    # collection_action :upload_csv do
    #   render "admin/csv/upload_csv"
    # end

    collection_action :import_csv_mobile, :method => :post do
      CsvDb.convert_save_books_mobile(params[:dump][:file])
      redirect_to :action => :index, :notice => "Mobile CSV imported successfully!"
    end

    collection_action :import_csv_new, :method => :post do
      CsvDb.convert_save_books_new(params[:dump][:file])
      redirect_to :action => :index, :notice => "CSV imported successfully!"
    end


    # collection_action :import_csv, :method => :post do
    #   CsvDb.convert_save_books(params[:dump][:file])
    #   redirect_to :action => :index, :notice => "CSV imported successfully!"
    # end

  filter :title
  filter :asin
  filter :book_status, :collection => BookStatus.all.map{ |bookstatus| [bookstatus.name, bookstatus.id]}.sort
  filter :category, :collection => Category.all.map{ |category| [category.name, category.id]}.sort
  filter :subcategory, :collection => Subcategory.all.map{ |subcategory| [subcategory.name, subcategory.id]}.sort
  filter :textbook_level, :collection => TextbookLevel.all.map{ |textbooklevel| [textbooklevel.name, textbooklevel.id]}.sort
  filter :textbook_sumlevel, :collection => TextbookSumlevel.all.map{ |textbooksumlevel| [textbooksumlevel.name, textbooksumlevel.id]}.sort
  filter :textbook_subject, :collection => TextbookSubject.all.map{ |textbooksubject| [textbooksubject.name, textbooksubject.id]}.sort
  filter :language, :collection => Language.all.map{ |language| [language.name, language.id]}.sort, :as => :check_boxes,:style =>'background-color:yellow'
  filter :read_level, :label => "Level"
  filter :publisher, :collection => Publisher.all.map{ |publisher| [publisher.name, publisher.id]}.sort
  filter :keywords
  filter :comments
  filter :authors
  filter :restricted, :as => :select
  filter :publishing_rights
  filter :origin , :label => "Country", :collection => Origin.all.map{ |origin| [origin.name, origin.id]}.sort
  filter :continent
  filter :pricingmodel, :label => "Pricing Model",:collection =>[['Free','free'],['Paid','paid']], :as => :select   
  filter :limited
  filter :created_at
  filter :updated_at
# filter :in_store, :label => "In Amazon Store", :as => :select
 

  index do
      selectable_column
      column("Status") {|book| book.book_status.name rescue nil} 
      column :asin rescue nil
		  column "Title" , :sortable => :title do |book|
        link_to book.title, edit_admin_book_path(book)    
      end
		  column "Author" do |book| 
			  link_to book.authors.map(&:name).join("<br />").html_safe, admin_author_path(book.authors)
		  end
      column :publisher, :sortable => false
      column :category, :sortable => false
      column :read_level, :label => "Level"
      column :language, :sortable => false
      column :rating
      column "Platform" do |book|   
          if (book.asin!="NULL") && (book.asin != 0)
              "Ereader"
            else
              "Mobile"  
          end
      end
      column "Remaining Copies" do |book|        
          if book.limited == nil
            book.limited=0
          end
          
          bookarr = Book.select("distinct books.*,publishers.name as pubname,count(devices.account_id) as copies,GROUP_CONCAT(distinct purchase_order_id) as group_purchaseorderid").joins(:publisher,:devices).where("books.id=?",book.id).group("pushes.book_id")
          totaldevices=0
          pushescount=0
          if bookarr != nil
            bookarr.each do |bookpushed|
            
              wherestring ="purchase_order_id in ("+bookpushed.group_purchaseorderid+")"
              totaldevices = Device.select("count(devices.account_id) as copies").where(wherestring)
             pushescount= (totaldevices[0]["copies"]).to_i
            end
            
            differenceofbooks = ((book.limited).to_i - pushescount).to_s
            differenceofbooks +" / " + (book.limited).to_s
          end
          
      end 

      # actions :defaults => false do |book|
      #     link_to "View", admin_book_path(book)
      # end
    end

    platformtype = ""

    csv do
          column("Status")      { |book| book.book_status.name rescue nil }
    
          column("Free Content") do |book| 
              book.publisher.free rescue nil
          end
          column("ASIN")        { |book| book.asin }

          column("Title")       { |book| book.title rescue nil}
          column "Author" do |book| 
              book.authors.map(&:name).join(", ").html_safe
          end
          column("Publisher")    { |book| book.publisher.name rescue nil }
          column("Country")       { |book| book.origin.name rescue nil}  
          column("Category")        { |book| book.category.name rescue nil }
          column("Subcategory")        { |book| book.subcategory.name rescue nil }
          column("Textbook Level")    { |book| book.textbook_level.name rescue nil}
          column("Textbook Subject")  { |book| book.textbook_subject.name rescue nil}
          column("Reading Level")     {|book| book.read_level.name rescue nil}
          column("Language")          { |book| book.language.name  rescue nil}
          column("Rating")            { |book| book.rating rescue nil }        
          column("Description")  { |book| book.description rescue nil }
    end

  
    form :partial => "bookform"
     

  #   form do |f|
  #     f.inputs "Book Details" do 
  #       f.input :authors, :collection => Author.all.sort_by(&:name) 
  #       f.input :asin, :input_html => { :size => 10 }
  #   		f.input :title, :input_html => { :size => 10 }
  #       f.input :book_status, :collection => BookStatus.all.map{ |stat| [stat.name, stat.id] }.sort
  #       f.input :language , :collection => Language.all.map{ |language| [language.name, language.id] }.sort
  #       f.input :category, :collection => Category.all.map{ |cat| [cat.name, cat.id] }.sort, :lable => "Content Type"
  #       f.input :subcategory, :collection => Subcategory.all.map{ |subc| [subc.name, subc.id] }.sort, :lable => "Content Subtype"       
  #       f.input :textbook_sumlevel, :hint => "(Only if genre is textbook)", :collection => TextbookSumlevel.all.map{ |stat| [stat.name, stat.id] }.sort
  #       f.input :textbook_subject, :hint => "(Only if genre is textbook)", :collection => TextbookSubject.all.map{ |stat| [stat.name, stat.id] }.sort
  #       f.input :keywords
  #       f.input :description
  #       f.input :mou_fname, :label => "MOU file name"
  #       f.input :read_level, :label => "Level"
  #       f.input :rating
  #       f.input :source_file
  #       f.input :source_cover
  #       f.input :epub
  #       f.input :mobi
  #       f.input :fixed_epub, :label => "Fixed layout epub"
  #       f.input :certified_by_national_board_of_education, :hint => "(Only if genre is textbook)", :label => "Certified by National Board of Education"
  #     end

      
  #     f.inputs "Publication Details" do
  #       f.input :publisher, :collection => Publisher.all.map{ |publisher| [publisher.name, publisher.id]}.sort
  #       f.input :copublished
  #       f.input :price
  #       f.input :restricted, :as => :boolean, :label =>"Rights restrictions", :hint => "(Specify in comments)"
  #       f.input :limited, :label =>"Copy restrictions", :hint => "(Number of copies to be pushed, following the MOU)"
  #       f.input :comments     

  #       f.input :origin
  #       f.input :textbook_level, :hint => "(Only if genre is textbook)", :collection => TextbookLevel.all.map{ |stat| [stat.name, stat.id] }.sort
      
  #     end


  #   f.inputs "Mobile Data" do
  #   f.input :binu_paperback_equivalent
  #   f.input :binu_source_file_name
		# f.input :binu_sort_title
		# f.input :binu_series
		# f.input :binu_creator_1_name
		# f.input :binu_creator_1_role
		# f.input :binu_publisher
		# f.input :binu_imprint
		# f.input :binu_pub_date,:as =>:date
		# f.input :binu_srp_inc_vat
		# f.input :binu_currency
		# f.input :binu_on_sale_date,:as =>:date
		# f.input :binu_langauge
		# f.input :binu_geo_rights
		# f.input :binu_subject1
		# f.input :binu_subject2
		# f.input :binu_bisac
		# f.input :binu_bic
		# f.input :binu_bic2
		# f.input :binu_fiction_subject2
		# f.input :binu_keyword
		# f.input :binu_short_description,:as =>:text
		# f.input :binu_not_for_sale
		# f.input :binu_ready_for_sale
		# f.input :binu_country, :as => :string
		
  #     end
  #   f.actions
       
  #   end

  controller do
    # loading textbooklevel by ajax call
    def changetextlevel     
      @textleveldata = TextbookLevel.find_all_by_origin_id(params[:origin_id])
      render :layout => false, :template => '/admin/books/changetextlevel'     
    end

    # loading subcategory by ajax call
    def loadsubcategory     
      @subcategorydata = Subcategory.find_all_by_category_id(params[:catg_id])
      render :layout => false, :template => '/admin/books/loadsubcategory'     
    end

     # def downloadforce
     #  send_file 'csvdownload/filekdp_07_26_05.csv'
     # end
  

  end


end
