require 'bundler'
Bundler.require
$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper.rb'
require 'open-uri'
require 'csv'
require 'pp'

class Index
    puts "Choisis le truc que tu veux faire!  Pour voir JSON, tappes JSON! Pour le Google Sheet, tappes GOOGLE! Pour le fichier CSV, tappes CSV!"
    print ">"
    choix = gets.chomp
    if choix =="JSON"
    puts "woohoo! le fichier peut être créé avec Townhall.save_as_JSON!"
    elsif choix =="GOOGLE"
    puts "woohoo! le fichier peut être créé avec Townhall.save_as_spreadsheet! tu peux le trouver dans https://docs.google.com/spreadsheets/d/1dShvJQ8MyP8ZkrNgno0Aj_qurjmhKd5450rsdwxTSNI/edit#gid=0"
    elsif choix =="CSV"
    
    puts "woohoo! le fichier peut être créé avec Townhall.save_as_csv!"
    end
end

Index
