# frozen_string_literal: true

class Brand
  BRANDS_CONFIG = YAML.load_file(Rails.root.join('config/brands.yml')).freeze
  SOURCE_URL = 'https://github.com/annex561/docuseal-brand'

  attr_reader :key, :name, :logo, :color, :url

  def initialize(key)
    @key = key
    config = BRANDS_CONFIG['brands'][key.to_s]
    raise ArgumentError, "Unknown brand key: #{key}" if config.nil?

    @name = config['name']
    @logo = config['logo']
    @color = config['color']
    @url = config['url']
  rescue ArgumentError
    default_config = BRANDS_CONFIG['brands'][BRANDS_CONFIG['default']]
    @key = BRANDS_CONFIG['default']
    @name = default_config['name']
    @logo = default_config['logo']
    @color = default_config['color']
    @url = default_config['url']
  end

  def self.for_host(host)
    key = BRANDS_CONFIG['hosts'][host] || BRANDS_CONFIG['default']
    new(key)
  end

  def self.for_submission(submission)
    folder_name = submission.template&.folder&.name
    key = BRANDS_CONFIG['folders'][folder_name] || BRANDS_CONFIG['default']
    new(key)
  end
end
