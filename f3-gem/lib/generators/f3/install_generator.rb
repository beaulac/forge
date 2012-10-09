module F3

  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    # ******************** THE APP ***************************
    def copy_assets
      directory "f3-rails/app/assets", "app/assets"
    end

    def copy_controllers
      directory "f3-rails/app/controllers", "app/controllers"
    end

    # what is the form_builder thing for, anyway?
    def copy_form_builders
      directory "f3-rails/app/form_builders", "app/form_builders"
    end

    def copy_helpers
      directory "f3-rails/app/helpers", "app/helpers"
    end

    def copy_mailers
      directory "f3-rails/app/mailers", "app/mailers"
    end

    def copy_models
      directory "f3-rails/app/models", "app/models"
    end

    def copy_sweepers
      directory "f3-rails/app/sweepers", "app/sweepers"
    end

    def copy_views
      directory "f3-rails/app/views", "app/views"
    end
    
    # ******************** THE CONFIG ************************
    def copy_config
      copy_file "f3-rails/config/application.rb", "config/application.rb"
      copy_file "f3-rails/config/i18n_fields.yml", "config/i18n_fields.yml"
      copy_file "f3-rails/config/routes.rb", "config/routes.rb"
      copy_file "f3-rails/config/s3.yml", "config/s3.yml"
      directory "f3-rails/config/environments", "config/environments"
      directory "f3-rails/config/initializers", "config/initializers"
      directory "f3-rails/config/locales", "config/locales"
    end

    # *********************** THE DB *************************
    def copy_db
      # TODO: copy over the initial migration

      directory "f3-rails/db/help", "db/help"
      copy_file "f3-rails/db/seeds.rb", "db/seeds.rb"
    end

    # ********************* THE DOCS *************************
    def copy_docs
      # TODO: there aren't any docs yet, really
    end

    # ********************* THE LIB **************************
    def copy_lib
      # TODO: what are we copying, and what are we keeping in the gem?
    end

    # ********************* THE PUBLIC ***********************
    def copy_public
      copy_file "f3-rails/public/favicon.ico", "public/favicon.ico"
      directory "f3-rails/public/flash", "public/flash"
      directory "f3-rails/public/javascripts/ckeditor", "public/javascripts/ckeditor"
      copy_file "f3-rails/public/pixel.gif", "public/pixel.gif"
    end

    # ******************* THE SCRIPTS ************************
    # TODO: determine if we need anything in there
    def copy_script

    end

    # ******************** THE SPECS *************************
    def copy_spec
      directory "f3-rails/spec", "spec"
    end

    # ********************* THE VENDOR ************************
    def copy_vendor
      directory "f3-rails/vendor", "vendor"
    end

  end

end
