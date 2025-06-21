package com.newarchitecturebridge;

import android.os.Handler;
import android.os.Looper;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.modules.core.DeviceEventManagerModule;

@ReactModule(name = NativeMessageModule.NAME)
public class NativeMessageModule extends NativeMessageModuleSpec {
    public static final String NAME = "NativeMessageModule";

    public NativeMessageModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    // 1. Send message (no return)
    @ReactMethod
    public void sendMessage(String message) {
        System.out.println("Received from JS: " + message);
    }

    // 2. Return message using Promise
    @ReactMethod
    public void getMessage(Promise promise) {
        try {
            String message = "Hello from Android";
            promise.resolve(message);
        } catch (Exception e) {
            promise.reject("GET_MESSAGE_ERROR", e);
        }
    }

    // 3. Return message using Callback
    @ReactMethod
    public void sendWithCallback(Callback callback) {
        String response = "Callback response from Android";
        callback.invoke(response);
    }

    // 4. Send event to JS
    @Override
    public void addListener(String eventName) {
        // Required for Turbo Module event emitters
        // This is called automatically when JS adds a listener
    }

    // 5. Remove event listeners
    @Override
    public void removeListeners(double count) {
        // Required for Turbo Module event emitters
        // This is called automatically when JS removes listeners
    }

    // 6. Emit an event to JS
    @ReactMethod
    public void startSendingEvents() {
        Handler handler = new Handler(Looper.getMainLooper());
        for (int i = 1; i <= 5; i++) {
            int delay = i * 1000;
            handler.postDelayed(() -> {
                WritableMap map = Arguments.createMap();
                map.putString("message", "Event at " + System.currentTimeMillis());
                getReactApplicationContext()
                    .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit("onTimerTick", map);
            }, delay);
        }
    }
}