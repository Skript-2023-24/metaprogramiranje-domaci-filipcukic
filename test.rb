require "google_drive"

module GoogleSheetHelper
    def row(row_index)
      rows.fetch(row_index - 1, nil)
    end
  
    def each
      rows.flatten.each { |cell| yield cell }
    end
  
    def detect_empty_rows(ws)
      ws.rows.each_with_index.select { |row, _index| row.all?(&:empty?) }.map(&:last)
    end
  
    def contains_total_subtotal?(row)
      row.any?(/total|subtotal/i)
    end
  
    def rows_without_total_subtotal
      rows.reject { |row| contains_total_subtotal?(row) }
    end
  
    def headers
      rows.first
    end
  
    define_method :method_missing do |name, *args, &block|
      if name.to_s.match?(/^[a-z]+Kolona$/)
        column_name = format_name_to_header(name)
        column(column_name)
      elsif args.empty? && block.nil? && (row = rows.find { |r| r.include?(name.to_s) })
        row
      else
        super
      end
    end
  
    private
  
    def format_name_to_header(name)
      name.to_s.split(/(?=[A-Z])/).map(&:capitalize).join(" ")
    end
  
    def column(header_name)
      index = headers.index(header_name)
      raise "Column '#{header_name}' not found" unless index
  
      rows.map { |row| row[index] }.extend(ColumnExtensions)
    end
  end
  
  module ColumnExtensions
    def sum
      map(&:to_f).sum
    end
  
    def avg
      non_empty_values = reject { |cell| cell.to_s.strip.empty? || cell.to_f.zero? }.map(&:to_f)
  
      return 0.0 if non_empty_values.empty?
  
      sum = non_empty_values.sum
      sum / non_empty_values.length
    end
  end
  
  
# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
session = GoogleDrive::Session.from_config("config.json")

ws = session.spreadsheet_by_key("1D_MJbudO4PntunW9lpio9gn64Uol2AMADkUtug6i24M").worksheets[0]

ws.extend(GoogleSheetHelper)
ws.extend(ColumnExtensions)


##1. zadatak
 data_array = []

 ws.rows.each do |row|
   data_array << row
 end
 p data_array

##2. zadatak
 t = ws
 p t.row(1)

##3. zadatak
 ws.each do |cell|
   puts cell
 end

 ##6. zadatak
  t = ws
  prva_kolona = t.prvaKolona
  p prva_kolona


##7. zadatak
 ws.rows.each do |row|
   p row
 end

##10. zadatak
 empty_rows = ws.detect_empty_rows(ws)

 ws.rows.each_with_index do |row, row_index|
   p "Row #{row_index + 1} is empty" if empty_rows.include?(row_index)
   p row unless empty_rows.include?(row_index)
 end

# Reloads the worksheet to get changes by other clients.
ws.reload
#ws2.reloads


