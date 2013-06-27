module Ui
  class MainWindow < Gtk::Window
    def initialize
      super

      set_title  "Auction sniper"
      signal_connect "destroy" do
        Gtk.main_quit
      end

      @status_label = Gtk::Label.new "Joining"
      add @status_label

      init_ui
      show_all
    end

    def show_status status
      @status_label.text = status
    end

    private

    def init_ui
      fixed = Gtk::Fixed.new
    end
  end
end
