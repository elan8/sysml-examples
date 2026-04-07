/*
 * Office workspace — minimal SysML v2 structural example (desk setup).
 */
package Office {
	doc /* Laptop, peripherals, and wall power for a typical office desk. */

	part wall_socket {
		port power;
	}

	requirement goodComputer {
		subject laptop : Laptop;
		doc /*
		 * A fast computer is required for running complex simulations and data analysis tasks efficiently.
		 * It should have a high-performance processor, ample RAM, and a solid-state drive (SSD) for quick data access.
		 * Additionally, it should support multiple USB ports and HDMI output for connecting peripherals and external displays.
		 * The computer should also be energy-efficient to minimize power consumption during extended use.
		 */
	}

	part def Laptop {
		port hdmi;
		port power;
		port usb1;
		port usb2;
	}

	part def Mouse {
		port usb;
	}

	part def Keyboard {
		port usb;
	}

	part def Monitor {
		port hdmi;
		port power;
	}

	part my_computer {
		part laptop : Laptop;
		part mouse : Mouse;
		part keyboard : Keyboard;
		part monitor : Monitor;
		connect laptop.hdmi to monitor.hdmi;
		connect laptop.power to wall_socket.power;
		connect laptop.usb1 to mouse.usb;
		connect laptop.usb2 to keyboard.usb;
		connect monitor.power to wall_socket.power;
	}
}
