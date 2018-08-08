require 'json'

require 'vagrancy/box_versions'

module Vagrancy
  class Box

    def initialize(name, group, filestore, request)
      @name = name
      @group = group
      @filestore = filestore
      @request = request
    end
    
    def exists?
      @filestore.exists? path
    end

    def path
      "#{@group}/#{@name}"
    end

    def to_json
      exists? ? { 
        :tag => path,
        :username => "#{@group}",
        :name => path,
        :private => true,
        :versions => BoxVersions.new(self, @filestore, @request).to_a
      }.to_json : '{ "errors": ["Resource not found!"], "success": false }'
    end

  end
end
