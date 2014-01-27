# coding: utf-8
require 'rubygems'

# Required gems
require 'hashie'
require 'typhoeus'

# Core dependencies
require 'net/https'
require 'uri'
require 'json'
require 'zip/zipfilesystem'
require 'csv'

# Library
require 'enigma/version'
require 'enigma/download'
require 'enigma/endpoint'
require 'enigma/response'
require 'enigma/client'

# Access to the engima API
module Enigma
  attr_accessor :key, :root_url, :api_version

  def self.root_url
    'https://api.enigma.io/'
  end

  def self.api_version
    'v2'
  end

  def self.key
    @key
  end
  def self.key=(k)
    @key = k
  end

  def self.logger
    @logger ||=
      begin
        logger = Logger.new(STDOUT)
        logger.level = Logger::INFO
        logger
      end
  end
end
