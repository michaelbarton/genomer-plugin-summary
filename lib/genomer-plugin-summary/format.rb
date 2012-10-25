require 'terminal-table'
require 'lazing'

module GenomerPluginSummary::Format

  DEFAULTS = {
    :justification => [],
    :width         => {},
    :format        => {}
  }

  def table(data,opts = {})
    opts = DEFAULTS.merge opts
    case opts[:output]
    when 'csv' then csv(data,opts)
    else            pretty(data,opts)
    end
  end

  def create_cells(data,opts)
    data.map do |row|
      if row == :separator
        :separator
      else
        row.each_with_index.map do |cell,index|
          format_cell(cell,
                      opts[:width][index],
                      opts[:justification][index],
                      opts[:format][index])
        end
      end
    end
  end

  def format_cell(cell,width,justification,format = nil)
    formatted = case format
                when String  then sprintf(format,cell)
                when Proc    then format.call(cell).to_s
                when nil     then cell.to_s
                end

    return formatted if width.nil?

    case justification
    when :right  then formatted.rjust(width)
    when :center then formatted.center(width)
    else              formatted.ljust(width)
    end
  end

  def csv(data,opts)
    opts[:width] = {}
    opts[:justification] = {}

    cells = create_cells(data,opts)

    cells.unshift opts[:headers] if opts[:headers]

    cells.compact.
      rejecting{|i| i == :separator}.
      mapping{|i| i.join(',')}.
      mapping{|i| i.gsub(' ','_')}.
      mapping{|i| i.gsub(/[()]/,'')}.
      mapping{|i| i.downcase}.
      to_a. join("\n") + "\n"
  end

  def pretty(data,opts)
    cells = create_cells(data,opts)

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
