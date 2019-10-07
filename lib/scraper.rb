require 'nokogiri'
require 'open-uri'
require 'pry'
    
    #name = doc.css(".student-card").first.css("h4).text
    #location = doc.css(".student-card").first.css("a p").text
    #profile = doc.css(".student-card a").first.attribute('href').value
# :twitter => doc.css(".social-icon-container a").attribute("href").value


class Scraper

  def self.scrape_index_page(index_url)
    scraped_students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card a").each do |student|
      scraped_students << {
      :name => student.css("h4").text,
      :location => student.css("p").text,
      :profile_url => student.attribute('href').value
      }
      end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    link_array = []
    scraped_info = {}
    doc = Nokogiri::HTML(open(profile_url))
   # binding.pry
    scraped_info = {
      :profile_quote => doc.css(".vitals-container").css(".profile-quote").text,
      :bio => doc.css(".description-holder").css("p").text
      }
    doc.css(".social-icon-container a").each do |link|
      link_array << link.attribute('href').value
    end
    link_array.each do |link|
      if link.include? "twitter"
        scraped_info[:twitter] = link
      elsif link.include? "linkedin"
        scraped_info[:linkedin] = link
      elsif link.include? "github"
        scraped_info[:github] = link 
      else 
        scraped_info[:blog] = link
      end
    end
    #binding.pry
    scraped_info
  end

end

