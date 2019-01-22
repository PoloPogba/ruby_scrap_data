#différentes gemmes requises pour que l'app marche

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

class Townhall                  #CLasse générale townhall qui englobe tout notre programme
  def self.get_townhall_email(townhall_url)           #méthode pour récupérer les emails des villes
    page = Nokogiri::HTML(open(townhall_url))       
    page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
  end

  def self.get_townhall_name(townhall_url)            #Méthode qui récupère les noms de villes
    page = Nokogiri::HTML(open(townhall_url))
    townhall_name = page.xpath('/html/body/div/main/section[1]/div/div/div/h1').text.slice(0..-8)
  end

  def self.get_townhall_urls                          #méthode qui récupère les urls 
    page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
    $urls = []
    list_hrefs = page.xpath('//a[@class="lientxt"]')    #chemin
    list_hrefs.each do |url|                            
      $urls << "http://annuaire-des-mairies.com"+url['href'].slice(1..-1)
    end
  end

  def self.scrap                                         # méthode qui assemble tout : nous donne le nom et le mail selon l'url
    get_townhall_urls
    $emails = []
    $urls.each do |town|
      hash = { get_townhall_name(town) => get_townhall_email(town)}
      $emails << hash
    end
    return $emails
end

  def self.save_as_JSON                           # méthode qui sauvegarde toutes les données recup avec scrap dans un fichier ".json"
    self.scrap                                  #scrap du dessus
    File.open("/db/emails.json", "w") do |town| #ouverture du fichier
    puts town.write(scrap.to_json)              #écriture
    end
  end

  def self.save_as_spreadsheet                    #méthode qui sauvegarde les données du scrap dans un spreadsheet google
    self.scrap
    big_hash = scrap.inject(:merge)             #Chaque hash du array se met das un gros hash "big_hash"
    session = GoogleDrive::Session.from_config("config.json")   #association du GoogleDrive avec nos keys du config.json
    spreadsheet = session.create_spreadsheet(title = "ruby-ville")  #creation du spreadsheet au nom de ruby ville
    ws = spreadsheet.worksheets[0]                                  #commence la feuille de travail
    ws[1,1] = "Ville"                           #premiere colone = ville ,deuxieme colone = mail
    ws[1, 2] = "E-mail"
    big_hash.each_key.with_index {|k, i| ws[i+2,1] = k} # en utilisant le gros hash on recupère chaque clés et on l'écrit ds la ligne suivante
    big_hash.each_value.with_index {|v, i| ws[i+2,2] = v} #en utilisant le gros hash on recupère chaque clés et on l'ecrit ds la ligne suivante
    ws.save()                                  #sauvegare
  end

  def self.save_as_csv                        #méthode pour sauvegarder les données dans un fichier csv
    self.scrap
    big_hash = scrap.inject(:merge)         #Données dans un gros hash
    CSV.open("/db/emails.csv", "wb") do |csv| #création du file .csv 
      big_hash.each do |city|     
        csv << city                     #pour chaque city du hash, on la met dans la page .csv
      end
    end
  end

end


