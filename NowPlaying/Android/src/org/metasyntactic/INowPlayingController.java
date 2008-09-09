/*
 * This file is auto-generated.  DO NOT MODIFY.
 * Original file: /Projects/metasyntactic/trunk/NowPlaying/Android/src/org/metasyntactic/INowPlayingController.aidl
 */
package org.metasyntactic;
import java.lang.String;
import android.os.RemoteException;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Binder;
import android.os.Parcel;
public interface INowPlayingController extends android.os.IInterface
{
/** Local-side IPC implementation stub class. */
public static abstract class Stub extends android.os.Binder implements org.metasyntactic.INowPlayingController
{
private static final java.lang.String DESCRIPTOR = "org.metasyntactic.INowPlayingController";
/** Construct the stub at attach it to the interface. */
public Stub()
{
this.attachInterface(this, DESCRIPTOR);
}
/**
 * Cast an IBinder object into an INowPlayingController interface,
 * generating a proxy if needed.
 */
public static org.metasyntactic.INowPlayingController asInterface(android.os.IBinder obj)
{
if ((obj==null)) {
return null;
}
org.metasyntactic.INowPlayingController in = (org.metasyntactic.INowPlayingController)obj.queryLocalInterface(DESCRIPTOR);
if ((in!=null)) {
return in;
}
return new org.metasyntactic.INowPlayingController.Stub.Proxy(obj);
}
public android.os.IBinder asBinder()
{
return this;
}
public boolean onTransact(int code, android.os.Parcel data, android.os.Parcel reply, int flags) throws android.os.RemoteException
{
switch (code)
{
case INTERFACE_TRANSACTION:
{
reply.writeString(DESCRIPTOR);
return true;
}
case TRANSACTION_setUserLocation:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _arg0;
_arg0 = data.readString();
this.setUserLocation(_arg0);
reply.writeNoException();
return true;
}
}
return super.onTransact(code, data, reply, flags);
}
private static class Proxy implements org.metasyntactic.INowPlayingController
{
private android.os.IBinder mRemote;
Proxy(android.os.IBinder remote)
{
mRemote = remote;
}
public android.os.IBinder asBinder()
{
return mRemote;
}
public java.lang.String getInterfaceDescriptor()
{
return DESCRIPTOR;
}
public void setUserLocation(java.lang.String userLocation) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeString(userLocation);
mRemote.transact(Stub.TRANSACTION_setUserLocation, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
}
static final int TRANSACTION_setUserLocation = (IBinder.FIRST_CALL_TRANSACTION + 0);
}
public void setUserLocation(java.lang.String userLocation) throws android.os.RemoteException;
}
