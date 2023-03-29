package com.dmcb.flutter_gps;

import static android.content.pm.PackageManager.PERMISSION_GRANTED;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.location.LocationManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterGpsPlugin */
public class FlutterGpsPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Result result;

  @Nullable private Activity activity;
  private static final int REQ_CODE = 9527;
  private static final String[] permissions = new String[]{
          Manifest.permission.ACCESS_FINE_LOCATION,
          Manifest.permission.ACCESS_COARSE_LOCATION,
  };

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_gps");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("gps")) {
      this.result = result;
      checkPermission();
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  private  void  checkPermission(){
    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
      for (String permission: permissions){
        if(activity != null){
          int i = ContextCompat.checkSelfPermission(activity,permission);
          if(i != PERMISSION_GRANTED){
            requestPermission();
            return;
          }
        }
      }
      requestCurrentGps();
    }else {
      requestCurrentGps();
    }

  }

  private void  requestPermission(){
    if(activity != null){
      ActivityCompat.requestPermissions(activity,permissions,REQ_CODE);
    }else {
      setFailed("A0002","权限请求-activity获取失败");
    }
  }

  private void  requestCurrentGps(){
    if(activity != null){
      LocationManager locationManager = (LocationManager) activity.getSystemService(Context.LOCATION_SERVICE);
      GpsListener gpsListener = new GpsListener(this,locationManager);
      gpsListener.handleGps();
    }else {
      setFailed("A0001","gps请求-activity获取失败");
    }
  }


  public void setResult(Object obj){
    Result result = this.result;
    this.result = null;
    result.success(obj);
  }

  private  void  setFailed(String code,String message){
    Map<String,String> map = new HashMap<>();
    map.put("code",code);
    map.put("message",message);
    setResult(map);
  }

}
