#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Entered'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name start _ end].freeze
    end

    def raw_end
      super.gsub('†', '').gsub(/\(.*\)/, '').tidy
    end

    def empty?
      tds[1].text == tds[2].text
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
