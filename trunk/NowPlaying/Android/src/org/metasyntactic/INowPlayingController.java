/*
 * This file is auto-generated.  DO NOT MODIFY.
 * Original file: /home/mjoshi/downloads/metasyntactic/NowPlaying/Android/src/org/metasyntactic/INowPlayingController.aidl
 */
package org.metasyntactic;
import java.lang.String;
import android.os.RemoteException;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Binder;
import android.os.Parcel;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.caches.scores.ScoreType;
import java.util.List;
import java.util.List;
import java.util.List;
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
case TRANSACTION_getUserLocation:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _result = this.getUserLocation();
reply.writeNoException();
reply.writeString(_result);
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
case TRANSACTION_getSearchDistance:
{
data.enforceInterface(DESCRIPTOR);
int _result = this.getSearchDistance();
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_setSearchDistance:
{
data.enforceInterface(DESCRIPTOR);
int _arg0;
_arg0 = data.readInt();
this.setSearchDistance(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_getSelectedTabIndex:
{
data.enforceInterface(DESCRIPTOR);
int _result = this.getSelectedTabIndex();
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_setSelectedTabIndex:
{
data.enforceInterface(DESCRIPTOR);
int _arg0;
_arg0 = data.readInt();
this.setSelectedTabIndex(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_getAllMoviesSelectedSortIndex:
{
data.enforceInterface(DESCRIPTOR);
int _result = this.getAllMoviesSelectedSortIndex();
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_setAllMoviesSelectedSortIndex:
{
data.enforceInterface(DESCRIPTOR);
int _arg0;
_arg0 = data.readInt();
this.setAllMoviesSelectedSortIndex(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_getAllTheatersSelectedSortIndex:
{
data.enforceInterface(DESCRIPTOR);
int _result = this.getAllTheatersSelectedSortIndex();
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_setAllTheatersSelectedSortIndex:
{
data.enforceInterface(DESCRIPTOR);
int _arg0;
_arg0 = data.readInt();
this.setAllTheatersSelectedSortIndex(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_getUpcomingMoviesSelectedSortIndex:
{
data.enforceInterface(DESCRIPTOR);
int _result = this.getUpcomingMoviesSelectedSortIndex();
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_setUpcomingMoviesSelectedSortIndex:
{
data.enforceInterface(DESCRIPTOR);
int _arg0;
_arg0 = data.readInt();
this.setUpcomingMoviesSelectedSortIndex(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_getMovies:
{
data.enforceInterface(DESCRIPTOR);
java.util.List<org.metasyntactic.data.Movie> _result = this.getMovies();
reply.writeNoException();
reply.writeTypedList(_result);
return true;
}
case TRANSACTION_getTheaters:
{
data.enforceInterface(DESCRIPTOR);
java.util.List<org.metasyntactic.data.Theater> _result = this.getTheaters();
reply.writeNoException();
reply.writeTypedList(_result);
return true;
}
case TRANSACTION_getTrailers:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.util.List<java.lang.String> _result = this.getTrailers(_arg0);
reply.writeNoException();
reply.writeStringList(_result);
return true;
}
case TRANSACTION_getScoreType:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.caches.scores.ScoreType _result = this.getScoreType();
reply.writeNoException();
if ((_result!=null)) {
reply.writeInt(1);
_result.writeToParcel(reply, android.os.Parcelable.PARCELABLE_WRITE_RETURN_VALUE);
}
else {
reply.writeInt(0);
}
return true;
}
case TRANSACTION_setScoreType:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.caches.scores.ScoreType _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.caches.scores.ScoreType.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
this.setScoreType(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_getScore:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
org.metasyntactic.data.Score _result = this.getScore(_arg0);
reply.writeNoException();
if ((_result!=null)) {
reply.writeInt(1);
_result.writeToParcel(reply, android.os.Parcelable.PARCELABLE_WRITE_RETURN_VALUE);
}
else {
reply.writeInt(0);
}
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
public java.lang.String getUserLocation() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getUserLocation, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
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
public int getSearchDistance() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getSearchDistance, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void setSearchDistance(int searchDistance) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(searchDistance);
mRemote.transact(Stub.TRANSACTION_setSearchDistance, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public int getSelectedTabIndex() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getSelectedTabIndex, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void setSelectedTabIndex(int index) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(index);
mRemote.transact(Stub.TRANSACTION_setSelectedTabIndex, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public int getAllMoviesSelectedSortIndex() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getAllMoviesSelectedSortIndex, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void setAllMoviesSelectedSortIndex(int index) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(index);
mRemote.transact(Stub.TRANSACTION_setAllMoviesSelectedSortIndex, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public int getAllTheatersSelectedSortIndex() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getAllTheatersSelectedSortIndex, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void setAllTheatersSelectedSortIndex(int index) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(index);
mRemote.transact(Stub.TRANSACTION_setAllTheatersSelectedSortIndex, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public int getUpcomingMoviesSelectedSortIndex() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getUpcomingMoviesSelectedSortIndex, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void setUpcomingMoviesSelectedSortIndex(int index) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(index);
mRemote.transact(Stub.TRANSACTION_setUpcomingMoviesSelectedSortIndex, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public java.util.List<org.metasyntactic.data.Movie> getMovies() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.util.List<org.metasyntactic.data.Movie> _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getMovies, _data, _reply, 0);
_reply.readException();
_result = _reply.createTypedArrayList(org.metasyntactic.data.Movie.CREATOR);
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.util.List<org.metasyntactic.data.Theater> getTheaters() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.util.List<org.metasyntactic.data.Theater> _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getTheaters, _data, _reply, 0);
_reply.readException();
_result = _reply.createTypedArrayList(org.metasyntactic.data.Theater.CREATOR);
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.util.List<java.lang.String> getTrailers(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.util.List<java.lang.String> _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getTrailers, _data, _reply, 0);
_reply.readException();
_result = _reply.createStringArrayList();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public org.metasyntactic.caches.scores.ScoreType getScoreType() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
org.metasyntactic.caches.scores.ScoreType _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getScoreType, _data, _reply, 0);
_reply.readException();
if ((0!=_reply.readInt())) {
_result = org.metasyntactic.caches.scores.ScoreType.CREATOR.createFromParcel(_reply);
}
else {
_result = null;
}
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void setScoreType(org.metasyntactic.caches.scores.ScoreType scoreType) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((scoreType!=null)) {
_data.writeInt(1);
scoreType.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_setScoreType, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public org.metasyntactic.data.Score getScore(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
org.metasyntactic.data.Score _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getScore, _data, _reply, 0);
_reply.readException();
if ((0!=_reply.readInt())) {
_result = org.metasyntactic.data.Score.CREATOR.createFromParcel(_reply);
}
else {
_result = null;
}
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
}
static final int TRANSACTION_getUserLocation = (IBinder.FIRST_CALL_TRANSACTION + 0);
static final int TRANSACTION_setUserLocation = (IBinder.FIRST_CALL_TRANSACTION + 1);
static final int TRANSACTION_getSearchDistance = (IBinder.FIRST_CALL_TRANSACTION + 2);
static final int TRANSACTION_setSearchDistance = (IBinder.FIRST_CALL_TRANSACTION + 3);
static final int TRANSACTION_getSelectedTabIndex = (IBinder.FIRST_CALL_TRANSACTION + 4);
static final int TRANSACTION_setSelectedTabIndex = (IBinder.FIRST_CALL_TRANSACTION + 5);
static final int TRANSACTION_getAllMoviesSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 6);
static final int TRANSACTION_setAllMoviesSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 7);
static final int TRANSACTION_getAllTheatersSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 8);
static final int TRANSACTION_setAllTheatersSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 9);
static final int TRANSACTION_getUpcomingMoviesSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 10);
static final int TRANSACTION_setUpcomingMoviesSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 11);
static final int TRANSACTION_getMovies = (IBinder.FIRST_CALL_TRANSACTION + 12);
static final int TRANSACTION_getTheaters = (IBinder.FIRST_CALL_TRANSACTION + 13);
static final int TRANSACTION_getTrailers = (IBinder.FIRST_CALL_TRANSACTION + 14);
static final int TRANSACTION_getScoreType = (IBinder.FIRST_CALL_TRANSACTION + 15);
static final int TRANSACTION_setScoreType = (IBinder.FIRST_CALL_TRANSACTION + 16);
static final int TRANSACTION_getScore = (IBinder.FIRST_CALL_TRANSACTION + 17);
}
public java.lang.String getUserLocation() throws android.os.RemoteException;
public void setUserLocation(java.lang.String userLocation) throws android.os.RemoteException;
public int getSearchDistance() throws android.os.RemoteException;
public void setSearchDistance(int searchDistance) throws android.os.RemoteException;
public int getSelectedTabIndex() throws android.os.RemoteException;
public void setSelectedTabIndex(int index) throws android.os.RemoteException;
public int getAllMoviesSelectedSortIndex() throws android.os.RemoteException;
public void setAllMoviesSelectedSortIndex(int index) throws android.os.RemoteException;
public int getAllTheatersSelectedSortIndex() throws android.os.RemoteException;
public void setAllTheatersSelectedSortIndex(int index) throws android.os.RemoteException;
public int getUpcomingMoviesSelectedSortIndex() throws android.os.RemoteException;
public void setUpcomingMoviesSelectedSortIndex(int index) throws android.os.RemoteException;
public java.util.List<org.metasyntactic.data.Movie> getMovies() throws android.os.RemoteException;
public java.util.List<org.metasyntactic.data.Theater> getTheaters() throws android.os.RemoteException;
public java.util.List<java.lang.String> getTrailers(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public org.metasyntactic.caches.scores.ScoreType getScoreType() throws android.os.RemoteException;
public void setScoreType(org.metasyntactic.caches.scores.ScoreType scoreType) throws android.os.RemoteException;
public org.metasyntactic.data.Score getScore(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
}
