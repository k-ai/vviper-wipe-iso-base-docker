from picotui.screen import *
from picotui.widgets import *
from picotui.menu import *
from picotui.context import Context

if __name__ == "__main__":
	s = Screen()
	try:
		s.init_tty()
		s.enable_mouse()
		s.attr_color(C_WHITE, C_BLUE)
		s.cls()
		s.attr_reset()
		d = Dialog(5, 5, 50, 12)

		# Can add a raw string to dialog, will be converted to WLabel
		d.add(11, 1, WLabel("Python + TUI are working...."))

		d.add(1, 15, "Dialog buttons:")
		b = WButton(8, "OK")
		b.finish_dialog = ACTION_OK
		d.add(10, 16, b)

		d.loop()
	finally:
		s.goto(0, 50)
		s.cursor(True)
		s.disable_mouse()
		s.deinit_tty()
