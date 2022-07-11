/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Processor.Registers : GLib.Object {

    public uint8 v[16];

    private uint16 _i;
    public uint16 i {
        get { return _i; }
        set {
            if (value > 0xFFF) {
                critical ("Invalid index register value: %d (Acceptable values are 0x000-0xFFF)", value);
                return;
            }
            this._i = value;
        }
    }

    private uint16 _pc;
    public uint16 pc {
        get { return _pc; }
        set {
            if (value > 0xFFF) {
                critical ("Invalid program counter value: %d (Acceptable values are 0x000-0xFFF)", value);
                GLib.Process.exit (0);
            }
            this._pc = value;
        }
    }

    construct {
        for (int cpu_register = 0; cpu_register < v.length; cpu_register++) {
            v[cpu_register] = 0x00;
        }
        i = 0x0000;
        pc = 0x200;
    }

}
