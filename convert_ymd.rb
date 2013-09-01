class ConvertYmd
  require "time"
  def self.convert(str)
    from_to_md = str.split(",")[0].split("-")    
    yyyy = str.split(",")[1].sub(/\s+/, " ")
    from_md = Time.parse("#{yyyy} #{from_to_md[0].sub(/\s+/, " ")}")
    to_md = Time.parse("#{yyyy} #{from_to_md[1].sub(/\s+/, " ")}")
    result = from_md.strftime("%Y/%m/%d") + " - " + to_md.strftime("%Y/%m/%d")
    return result
  end
end
