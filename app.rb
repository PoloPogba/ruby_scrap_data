require 'bundler'
Bundler.require
$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper.rb'
require 'open-uri'
require 'csv'
require 'pp'

class Start
    puts "Choisis le truc que tu veux faire!  Pour voir JSON, tappes JSON! Pour le Google Sheet, tappes GOOGLE! Pour le fichier CSV, tappes CSV!"
    print ">"
    choix = gets.chomp
    if choix =="JSON"
    Townhall.save_as_JSON
    puts "woohoo! le fichier vient d'être créé!"
    elsif choix =="GOOGLE"
    Townhall.save_as_spreadsheet
    puts "woohoo! le fichier vient d'être créé! tu peux le trouver dans https://docs.google.com/spreadsheets/d/1dShvJQ8MyP8ZkrNgno0Aj_qurjmhKd5450rsdwxTSNI/edit#gid=0"
    elsif choix =="CSV"
    Townhall.save_as_csv
    puts "woohoo! le fichier vient d'être créé!"
    end
end

Start
