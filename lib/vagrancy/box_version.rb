module Vagrancy
  class BoxVersion

    def initialize(version, parent, filestore, request)
      @version = version
      @parent = parent
      @filestore = filestore
      @request = request
    end

    def to_h
      { 
        :version => @version, 
        :status => "released",
        :release_url => "http://%s:%s/api/v1/box/%s/version/%s/release" % [ @request.host, @request.port, @parent.path, @version ],
        :providers => providers.collect { |p| p.to_h } 
      }
    end

    def to_json
      to_h.to_json
    end

    def exists?
      providers.any? { |p| p.exists? }
    end

    private 

    def path
      @parent.path + '/' + @version
    end

    def providers
      @providers ||= @filestore.directories_in(path).collect do |provider|
        ProviderBox.new(provider, @version, @parent, @filestore, @request)
      end
    end

  end
end
