require 'terminal-table'
require 'lazing'

module GenomerPluginSummary::Format

  DEFAULTS = {
    :justification => [],
    :width         => {},
    :format        => {}
  }

  def format_cell(cell,width,justification,format = nil)
    formatted = format.nil? ? cell.to_s : sprintf(format,cell)
    return formatted if width.nil?

    case justification
    when :right  then formatted.rjust(width)
    when :center then formatted.center(width)
    else              formatted.ljust(width)
    end
  end

  def table(data,opts = {})
    opts = DEFAULTS.merge opts

    cells = data.map do |row|
      if row == :separator
        row
      else
        row.each_with_index.map do |cell,index|
          format_cell(cell,
                      opts[:width][index],
                      opts[:justification][index],
                      opts[:format][index])
        end
      end
    end

    if opts[:headers]
      cells.unshift :separator
      cells.unshift(opts[:headers].each_with_index.map do |header,index|
        width = opts[:width][index] || cells.mapping{|c| c[index].length }.max
        format_cell(header, width, :center)
      end)
    end

    table = Terminal::Table.new do |t|
      cells.each{|c| t << c}
    end
    opts[:justification].each{|(k,v)| table.align_column k, v }
    table.title ||= opts[:title]
    table.to_s + "\n"
  end

end
