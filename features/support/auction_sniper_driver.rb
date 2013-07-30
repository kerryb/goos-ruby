class AuctionSniperDriver
  def initialize application
    @application = application
  end

  def wait_for_app_to_start
    wait_for { @application.main_window.title == Ui::MainWindow::APPLICATION_TITLE }
    wait_for_column_headers "Item", "Last price", "Last bid", "State"
  end

  def wait_for_displayed_sniper_status *expected_values
    wait_for { displayed_rows.include? expected_values } or fail(
      %{Expected a row containing #{expected_values.inspect}, but table contained #{displayed_rows.inspect}})
  end

  private

  def window
    @application.main_window
  end

  def wait_for_window_title title
    wait_for { window.title == title } or fail(
      %{Expected window title to be "#{title}", but was "#{window.title}"})
  end

  def wait_for_column_headers *headers
    wait_for { displayed_headers == headers } or fail(
      %{Expected displayed headers to be #{headers.inspect}, but were #{displayed_headers.inspect}})
  end

  def wait_for
    Timeout.timeout 2 do
      sleep 0.01 until yield
      return true
    end
  rescue Timeout::Error
    false
  end

  def displayed_rows
    table_model = snipers_table.model
    rows = []
    table_model.each do |_model, _path, iterator|
      rows << table_model.n_columns.times.map {|n| iterator[n]}
    end
    rows
  end

  def snipers_table
    element_with_name "snipers"
  end

  def element_with_name name
    element_and_children(window).flatten.find {|elem| elem.name == name }
  end

  def element_and_children element
    return [element] unless element.respond_to? :children
    [element] + element.children.map {|w| element_and_children w }
  end

  def displayed_headers
    window.child.columns.map(&:title)
  end
end
