require 'rubygems'
require 'nokogiri'
require 'rspec'
require 'open-uri'
require "google_drive"
require 'json'
require 'pry'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'csv'

class Townhall
    def self.get_townhall_email(townhall_url)
        page = Nokogiri::HTML(open(townhall_url))
        page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
    end

    def self.get_townhall_name(townhall_url)
        page = Nokogiri::HTML(open(townhall_url))
        townhall_name = page.xpath('/html/body/div/main/section[1]/div/div/div/h1').text.slice(0..-8)
    end

    def self.get_townhall_urls
        page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
        $urls = []
        
        list_hrefs = page.xpath('//a[@class="lientxt"]')
        
        list_hrefs.each do |url|
            $urls << "http://annuaire-des-mairies.com"+url['href'].slice(1..-1)
        end
    end

    def self.scrap
        get_townhall_urls
        $emails = []
        
        $urls.each do |town|
            hash = { get_townhall_name(town) => get_townhall_email(town)}
            $emails << hash
        end
        return $emails
    end

    def self.save_as_JSON
        self.scrap
        File.open("/db/emails.json", "w") do |town|
        puts town.write(scrap.to_json)
        end
    end

    def self.save_as_spreadsheet
        self.scrap
        big_hash = scrap.inject(:merge)
        session = GoogleDrive::Session.from_config("config.json")
        spreadsheet = session.create_spreadsheet(title = "ruby-ville")
        ws = spreadsheet.worksheets[0]
        ws[1,1] = "Ville"
        ws[1, 2] = "E-mail"
        big_hash.each_key.with_index {|k, i| ws[i+2,1] = k}
        big_hash.each_value.with_index {|v, i| ws[i+2,2] = v}
        ws.save()
    end

    def self.save_as_csv
        self.scrap
        big_hash = scrap.inject(:merge)
        CSV.open("/db/emails.csv", "wb") do |csv|
            big_hash.each do |city|
                csv << city
            end
        end
    end

end

Townhall.save_as_csv
