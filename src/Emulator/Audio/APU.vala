/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Audio.APU : GLib.Object {

    public GLib.File file { get; construct; }

    private Canberra.Context context;

    public APU () {
        Object (
            file: GLib.File.new_for_path (Constants.PKG_DATA_DIR + "/" + "beep.wav")
        );
    }

    construct {
        if (!file.query_exists ()) {
            warning ("Audio file not found: %s", file.get_path ());
        }
        Canberra.Context ctx;
        if (Canberra.Context.create (out ctx) != Canberra.SUCCESS) {
            warning ("Failed to initialize canberra context");
        }
        if (ctx.change_props (
                Canberra.PROP_APPLICATION_ID, Constants.APP_ID,
                Canberra.PROP_APPLICATION_NAME, Constants.APP_NAME,
                null
            ) != Canberra.SUCCESS) {
            warning ("Failed to set canberra context properties");
        }
        if (ctx.open () != Canberra.SUCCESS) {
            warning ("Failed to open canberra context");
        }
        this.context = (owned) ctx;
    }

    private static double amplitude_to_decibels (double amplitude) {
        return 20.0 * Math.log10 (amplitude);
    }

    public void play () {
        Canberra.Proplist properties;
        if (Canberra.Proplist.create (out properties) != Canberra.SUCCESS) {
            warning ("Failed to create canberra properties");
        }
        properties.sets (Canberra.PROP_MEDIA_NAME, "beep");
        properties.sets (Canberra.PROP_MEDIA_FILENAME, file.get_path ());
        properties.sets (Canberra.PROP_CANBERRA_VOLUME, ((float) amplitude_to_decibels (1.0)).to_string ());
        Idle.add (() => {
            var status = context.play_full (0, properties);
            if (status != Canberra.SUCCESS) {
                warning ("Failed to play sound: %s", Canberra.strerror (status));
            }
            return false;
        }, GLib.Priority.HIGH);

    }

    public void stop () {

    }

}
