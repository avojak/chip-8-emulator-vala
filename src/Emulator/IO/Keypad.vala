/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.IO.Keypad : GLib.Object {

    public static uint8[] keys = new uint8[] {
        0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF
    };

    // TODO: This should be configurable
    public static Gee.Map<char, uint8> keypad_mapping;

    private Gee.Map<uint8, bool> key_states;

    static construct {
        keypad_mapping = new Gee.HashMap<char, uint8> ();
        keypad_mapping.set ('1', 0x1);
        keypad_mapping.set ('2', 0x2);
        keypad_mapping.set ('3', 0x3);
        keypad_mapping.set ('4', 0xC);
        keypad_mapping.set ('Q', 0x4);
        keypad_mapping.set ('W', 0x5);
        keypad_mapping.set ('E', 0x6);
        keypad_mapping.set ('R', 0xD);
        keypad_mapping.set ('A', 0x7);
        keypad_mapping.set ('S', 0x8);
        keypad_mapping.set ('D', 0x9);
        keypad_mapping.set ('F', 0xE);
        keypad_mapping.set ('Z', 0xA);
        keypad_mapping.set ('X', 0x0);
        keypad_mapping.set ('C', 0xB);
        keypad_mapping.set ('V', 0xF);
    }

    construct {
        key_states = new Gee.HashMap<uint8, bool> ();
        foreach (uint8 key in keys) {
            key_states.set (key, false);
        }
    }

    public void key_pressed (uint8 key) {
        key_states.set (key, true);
    }

    public void key_released (uint8 key) {
        key_states.set (key, false);
    }

    public bool is_key_pressed (uint8 key) {
        return key_states.get (key);
    }

    public uint8? get_key_presssed () {
        foreach (var entry in key_states.entries) {
            if (entry.value) {
                return entry.key;
            }
        }
        return null;
    }

}
