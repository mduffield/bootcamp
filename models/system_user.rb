class  SystemUser < Sequel::Model
        
        plugin :validation_helpers

        def validate
                super
                validates_presence [:username, :password, :access]
                validates_unique :username
        end
        
        set_schema do
                primary_key :id
                varchar :username
                varchar :password
                varchar :access
                varchar :email
        end
        
        unless table_exists?
                create_table
        end
        
end
