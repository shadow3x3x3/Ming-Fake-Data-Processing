require 'csv'

module OutputUtil
  def self.output_start_codes_csv(path, dataset)
    CSV.open(path, "wb",
      write_headers: true,
      headers: ["a", "b", "c", "d", "e", "f", "g",
                "h", "i", "j", "k", "l", "m", "n",
                "o", "p", "q", "r", "s", "t", "days"]) do |csv|
      dataset.each { |data| csv << data }
    end
  end

  def self.output_setting_csv(path, dataset)
    CSV.open(path, "wb",
      write_headers: true,
      headers: ["a", "b", "c", "d", "e", "f", "g",
                "h", "i", "j", "k", "l", "m", "n",
                "o", "p", "q", "r", "s", "t"]) do |csv|
      csv << dataset
    end
  end
end
