ActiveAdmin.register Author do
	index do
        column :name 
		column :origin
		column "Books" do |author| 
			author.books.map{ |book| book.title }.join("<br />").html_safe
		end

        default_actions
    end

    form do |f|
    	f.inputs "Author Details" do
    		f.input :name
        	f.input :origin, :collection => Origin.all.map{ |origin| [origin.name, origin.id] }
#        	f.input :comments
        end
        
        f.buttons

    end
end

ActiveAdmin.register PublishingRight do
    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Publishing Rights Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register Language do
    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Language Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register Genre do
    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Genre Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register Platform do
    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Platform Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register Level do
    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Level Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register Publisher do
    index do
        column :name 
        column :origin
        default_actions
    end

    form do |f|
        f.inputs "Publisher Details" do
            f.input :name
            f.input :origin
        end
        
        f.buttons
    end
end

