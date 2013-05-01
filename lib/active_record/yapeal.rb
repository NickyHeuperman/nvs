module ActiveRecord
  class Yapeal < ActiveRecord::Base
    self.abstract_class = true
    establish_connection(MyApp::Application.config.yapeal_url)

  end

  class YapealMigration < ActiveRecord::Migration
    def connection
      ActiveRecord::Yapeal.connection 
    end
  end

end