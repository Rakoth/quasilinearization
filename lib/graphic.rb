require 'gruff'
require 'fileutils'

class Graphic
  def initialize params = {}
    g = Gruff::Line.new
    g.hide_legend = params[:hide_legend]
    g.margins = params[:margins] || 25
    g.left_margin = params[:left_margin] || 70
    g.dot_radius = params[:dot_radius] || 0
    g.line_width = params[:line_width] || 1
    g.title = params[:title] || "Example"

    params[:datas].each do |label, data|
      g.data label, data.map{|val| val.to_f.round_to(4)}
    end

    g.labels = params[:keys].inject({}) do |labels, key|
      labels.merge(params[:keys].index(key) => key.to_s)
    end
    path = "results/#{Time.now.strftime('%d_%H_%M')}"
    FileUtils.mkdir_p(path)
    g.write("#{path}/#{params[:title]}.png")
  end
end
