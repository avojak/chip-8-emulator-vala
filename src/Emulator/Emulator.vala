/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Emulator : GLib.Object {

    public const string HARDWARE_NAME = "CHIP-8";
    public const string COMMON_NAME = "CHIP-8";
    public const string SUPPORTED_EXTENSIONS[] = { "ch8", "c8" };

    private const int BUFFER_SIZE = 512;

    private Thread<int>? emulator_thread;
    private Cancellable? cancellable;

    private CHIP8.Memory.MMU mmu;
    private CHIP8.Processor.CPU cpu;
    private CHIP8.Graphics.PPU ppu;
    private CHIP8.Audio.APU apu;
    private CHIP8.IO.Keypad keypad;
    private CHIP8.Graphics.Display display;

    construct {
        mmu = new CHIP8.Memory.MMU ();
        ppu = new CHIP8.Graphics.PPU (mmu);
        apu = new CHIP8.Audio.APU ();
        keypad = new CHIP8.IO.Keypad ();
        cpu = new CHIP8.Processor.CPU (mmu, ppu, apu, keypad);
        display = new CHIP8.Graphics.Display (ppu);
    }

    public void load_rom (GLib.File file) {
        if (!file.query_exists ()) {
            warning ("File not found: %s", file.get_path ());
            return;
        }
        try {
            GLib.FileInfo info = file.query_info ("*", FileQueryInfoFlags.NONE);
            info.get_size ();
            // TODO: Validate ROM size against max size
        } catch (GLib.Error e) {
            warning ("Error querying ROM file info: %s", e.message);
        }
        try {
            ssize_t bytes_read = 0; // Total bytes read
            ssize_t buffer_bytes = 0; // Bytes read into the buffer
            uint8[] buffer = new uint8[BUFFER_SIZE];
            GLib.FileInputStream input_stream = file.read ();
            while ((buffer_bytes = input_stream.read (buffer, cancellable)) != 0) {
                for (int i = 0; i < buffer_bytes; i++) {
                    mmu.set_byte (CHIP8.Memory.MMU.ROM_OFFSET + (int) bytes_read + i, buffer[i]);
                }
                bytes_read += buffer_bytes;
            }
        } catch (GLib.Error e) {
            critical ("Error loading ROM file (%s): %s", file.get_path (), e.message);
            // TODO: Show error
        }
    }

    public void start () {
        if (emulator_thread != null) {
            warning (@"$COMMON_NAME emulator is already running");
            return;
        }
        cancellable = new Cancellable ();
        emulator_thread = new Thread<int> (@"$HARDWARE_NAME emulator", do_run);
    }

    private int do_run () {
        while (true) {
            if (cancellable.is_cancelled ()) {
                break;
            }
            tick ();
            // TODO: Don't tick the CPU this much
            //  GLib.Thread.usleep (500);
        }
        return 0;
    }

    private void tick () {
        cpu.tick ();
    }

    public void stop () {
        cancellable.cancel ();
        emulator_thread = null;
    }

    public Gtk.Container get_display () {
        return display;
    }

    public void show (MainWindow main_window) {
        //  if (display == null) {
        //      display = new CHIP8.Graphics.Display (main_window, ppu);
        //      display.show_all ();
        //      display.key_pressed.connect ((keyboard_key) => {
        //          keypad.key_pressed (CHIP8.IO.Keypad.keypad_mapping.get (keyboard_key));
        //      });
        //      display.key_released.connect ((keyboard_key) => {
        //          keypad.key_released (CHIP8.IO.Keypad.KEYPAD_MAPPING.get (keyboard_key));
        //      });
        //      display.destroy.connect (() => {
        //          display = null;
        //          debugger = null;
        //          stop ();
        //          closed ();
        //      });
        //      //  debugger = new CHIP8.Debug.Dialog (display);
        //      //  debugger.show_all ();
        //      //  debugger.present ();
        //  }
        //  display.present ();
    }

    public void hide () {
        //  if (display != null) {
        //      display.close ();
        //  }
    }

    public void key_pressed (char key) {
        if (CHIP8.IO.Keypad.keypad_mapping.has_key (key)) {
            keypad.key_pressed (CHIP8.IO.Keypad.keypad_mapping.get (key));
        }
    }

    public void key_released (char key) {
        if (CHIP8.IO.Keypad.keypad_mapping.has_key (key)) {
            keypad.key_released (CHIP8.IO.Keypad.keypad_mapping.get (key));
        }
    }

    public signal void closed ();

}
