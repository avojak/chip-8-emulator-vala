/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Settings : GLib.Settings {

    public int pos_x {
        get { return get_int ("pos-x"); }
        set { set_int ("pos-x", value); }
    }

    public int pos_y {
        get { return get_int ("pos-y"); }
        set { set_int ("pos-y", value); }
    }

    public int window_width {
        get { return get_int ("window-width"); }
        set { set_int ("window-width", value); }
    }

    public int window_height {
        get { return get_int ("window-height"); }
        set { set_int ("window-height", value); }
    }

    public double instruction_frequency {
        get { return get_double ("instruction-frequency"); }
        set { set_double ("instruction-frequency", value); }
    }

    public string foreground_color {
        owned get { return get_string ("foreground-color"); }
        set { set_string ("foreground-color", value); }
    }

    public string background_color {
        owned get { return get_string ("background-color"); }
        set { set_string ("background-color", value); }
    }

    public Settings () {
        Object (schema_id: Constants.APP_ID);
    }

}
