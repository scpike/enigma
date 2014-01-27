# coding: utf-8
module Enigma
  # Generic Enigma endpoint. Knows how to construct a URL, request it,
  # and wrap the response in an `Enigma::Response`
  #
  # Assumes the api endpoints for its descendants are a lowercase
  # version of their class names
  #
  # Handles some nice conversion of select, search, and where clauses
  # from ruby hashes to string parameters
  #
  class Endpoint
    attr_accessor :params, :datapath, :url

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def initialize(datapath, opts = {})
      self.datapath = datapath
      self.params = opts
    end

    def self.url_chunk
      to_s.gsub(/.*::/, '').downcase
    end

    def params
      @params[:where] = serialize_where(@params[:where]) if @params[:where]
      @params[:search] = serialize_search(@params[:search]) if @params[:search]
      @params[:select] = serialize_select(@params[:select]) if @params[:select]
      @params
    end

    # Serialize a where clause. Allows you to pass in a hash and have
    # it converted to an equality where
    #
    # >  Filter results with a SQL-style "where" clause. Only applies to
    # >  numerical columns - use the "search" parameter for strings. Valid
    # >  operators are >, < and =. Only one "where" clause per request is
    # >  currently supported.
    #
    # @param [String|Hash] where clause to convert
    # @return [String] parameter ready for the request
    #
    def serialize_where(where)
      if where.is_a? Hash
        column, value = where.first
        "#{column}=#{value}"
      else
        where
      end
    end

    # Serialize a search clause. Allows you to pass in a hash of
    # one or more fieldName: value pairs
    #
    # @param [String|Hash] search clause to convert
    # @return [String] parameter ready for the request
    #
    def serialize_search(search)
      if search.is_a? Hash
        search.map do |field, value|
          value = [value].flatten.join('|')
          "@#{field} (#{value})"
        end.join ' '
      else
        search
      end
    end

    # Serialize a search clause. Allows you to pass in an array of
    # column names
    #
    # @param [String|Array] select clause to convert
    # @return [String] parameter ready for the request
    #
    def serialize_select(select)
      if select.is_a? Enumerable
        select.join(',')
      else
        select
      end
    end

    # Endpoints show up in urls as a lowercase version of their class
    # names
    def url_chunk
      self.class.url_chunk
    end

    def path
      [Enigma.api_version, url_chunk, Enigma.key, datapath].join('/')
    end

    def url
      URI.join(Enigma.root_url, path).to_s
    end

    def request
      Enigma.logger.info "Making request to #{url}"
      req = Typhoeus::Request.new(url, method: :get, params: params).run
      Response.parse(req)
    end
  end
end

Dir[File.dirname(__FILE__) + '/endpoints/*.rb'].each { |file|  require(file) }
