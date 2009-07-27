/*
 * This file is auto-generated.  DO NOT MODIFY.
 * Original file: /Projects/metasyntactic/trunk/NowPlaying/Android/src/org/metasyntactic/services/INowPlayingService.aidl
 */
package org.metasyntactic.services;
import java.lang.String;
import android.os.RemoteException;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Binder;
import android.os.Parcel;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;
import org.metasyntactic.data.Score;
import java.util.List;
import java.util.List;
import java.util.List;
import java.util.List;
public interface INowPlayingService extends android.os.IInterface
{
/** Local-side IPC implementation stub class. */
public static abstract class Stub extends android.os.Binder implements org.metasyntactic.services.INowPlayingService
{
private static final java.lang.String DESCRIPTOR = "org.metasyntactic.services.INowPlayingService";
/** Construct the stub at attach it to the interface. */
public Stub()
{
this.attachInterface(this, DESCRIPTOR);
}
/**
 * Cast an IBinder object into an INowPlayingService interface,
 * generating a proxy if needed.
 */
public static org.metasyntactic.services.INowPlayingService asInterface(android.os.IBinder obj)
{
if ((obj==null)) {
return null;
}
android.os.IInterface iin = (android.os.IInterface)obj.queryLocalInterface(DESCRIPTOR);
if (((iin!=null)&&(iin instanceof org.metasyntactic.services.INowPlayingService))) {
return ((org.metasyntactic.services.INowPlayingService)iin);
}
return new org.metasyntactic.services.INowPlayingService.Stub.Proxy(obj);
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
case TRANSACTION_getUserAddress:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _result = this.getUserAddress();
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_setUserAddress:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _arg0;
_arg0 = data.readString();
this.setUserAddress(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_getLocationForAddress:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _arg0;
_arg0 = data.readString();
org.metasyntactic.data.Location _result = this.getLocationForAddress(_arg0);
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
case TRANSACTION_getTrailer:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.lang.String _result = this.getTrailer(_arg0);
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_getReviews:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.util.List<org.metasyntactic.data.Review> _result = this.getReviews(_arg0);
reply.writeNoException();
reply.writeTypedList(_result);
return true;
}
case TRANSACTION_getAmazonAddress:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.lang.String _result = this.getAmazonAddress(_arg0);
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_getIMDbAddress:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.lang.String _result = this.getIMDbAddress(_arg0);
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_getWikipediaAddress:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.lang.String _result = this.getWikipediaAddress(_arg0);
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_getTheatersShowingMovie:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.util.List<org.metasyntactic.data.Theater> _result = this.getTheatersShowingMovie(_arg0);
reply.writeNoException();
reply.writeTypedList(_result);
return true;
}
case TRANSACTION_getMoviesAtTheater:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Theater _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Theater.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.util.List<org.metasyntactic.data.Movie> _result = this.getMoviesAtTheater(_arg0);
reply.writeNoException();
reply.writeTypedList(_result);
return true;
}
case TRANSACTION_getPerformancesForMovieAtTheater:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
org.metasyntactic.data.Theater _arg1;
if ((0!=data.readInt())) {
_arg1 = org.metasyntactic.data.Theater.CREATOR.createFromParcel(data);
}
else {
_arg1 = null;
}
java.util.List<org.metasyntactic.data.Performance> _result = this.getPerformancesForMovieAtTheater(_arg0, _arg1);
reply.writeNoException();
reply.writeTypedList(_result);
return true;
}
case TRANSACTION_getScoreType:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _result = this.getScoreType();
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_setScoreType:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _arg0;
_arg0 = data.readString();
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
case TRANSACTION_getPoster:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
byte[] _result = this.getPoster(_arg0);
reply.writeNoException();
reply.writeByteArray(_result);
return true;
}
case TRANSACTION_getPosterFile_safeToCallFromBackground:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.lang.String _result = this.getPosterFile_safeToCallFromBackground(_arg0);
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_getSynopsis:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.lang.String _result = this.getSynopsis(_arg0);
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_prioritizeMovie:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Movie _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Movie.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
this.prioritizeMovie(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_isAutoUpdateEnabled:
{
data.enforceInterface(DESCRIPTOR);
boolean _result = this.isAutoUpdateEnabled();
reply.writeNoException();
reply.writeInt(((_result)?(1):(0)));
return true;
}
case TRANSACTION_setAutoUpdateEnabled:
{
data.enforceInterface(DESCRIPTOR);
boolean _arg0;
_arg0 = (0!=data.readInt());
this.setAutoUpdateEnabled(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_getSearchDate:
{
data.enforceInterface(DESCRIPTOR);
long _result = this.getSearchDate();
reply.writeNoException();
reply.writeLong(_result);
return true;
}
case TRANSACTION_setSearchDate:
{
data.enforceInterface(DESCRIPTOR);
long _arg0;
_arg0 = data.readLong();
this.setSearchDate(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_getUpcomingMovies:
{
data.enforceInterface(DESCRIPTOR);
java.util.List<org.metasyntactic.data.Movie> _result = this.getUpcomingMovies();
reply.writeNoException();
reply.writeTypedList(_result);
return true;
}
case TRANSACTION_getDataProviderState:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _result = this.getDataProviderState();
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_isStale:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Theater _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Theater.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
boolean _result = this.isStale(_arg0);
reply.writeNoException();
reply.writeInt(((_result)?(1):(0)));
return true;
}
case TRANSACTION_getShowtimesRetrievedOnString:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Theater _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Theater.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
java.lang.String _result = this.getShowtimesRetrievedOnString(_arg0);
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_addFavoriteTheater:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Theater _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Theater.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
this.addFavoriteTheater(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_removeFavoriteTheater:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Theater _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Theater.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
this.removeFavoriteTheater(_arg0);
reply.writeNoException();
return true;
}
case TRANSACTION_isFavoriteTheater:
{
data.enforceInterface(DESCRIPTOR);
org.metasyntactic.data.Theater _arg0;
if ((0!=data.readInt())) {
_arg0 = org.metasyntactic.data.Theater.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
boolean _result = this.isFavoriteTheater(_arg0);
reply.writeNoException();
reply.writeInt(((_result)?(1):(0)));
return true;
}
}
return super.onTransact(code, data, reply, flags);
}
private static class Proxy implements org.metasyntactic.services.INowPlayingService
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
public java.lang.String getUserAddress() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getUserAddress, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void setUserAddress(java.lang.String address) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeString(address);
mRemote.transact(Stub.TRANSACTION_setUserAddress, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public org.metasyntactic.data.Location getLocationForAddress(java.lang.String address) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
org.metasyntactic.data.Location _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeString(address);
mRemote.transact(Stub.TRANSACTION_getLocationForAddress, _data, _reply, 0);
_reply.readException();
if ((0!=_reply.readInt())) {
_result = org.metasyntactic.data.Location.CREATOR.createFromParcel(_reply);
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
public void setSearchDistance(int distance) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(distance);
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
public java.lang.String getTrailer(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getTrailer, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.util.List<org.metasyntactic.data.Review> getReviews(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.util.List<org.metasyntactic.data.Review> _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getReviews, _data, _reply, 0);
_reply.readException();
_result = _reply.createTypedArrayList(org.metasyntactic.data.Review.CREATOR);
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.lang.String getAmazonAddress(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getAmazonAddress, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.lang.String getIMDbAddress(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getIMDbAddress, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.lang.String getWikipediaAddress(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getWikipediaAddress, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.util.List<org.metasyntactic.data.Theater> getTheatersShowingMovie(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.util.List<org.metasyntactic.data.Theater> _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getTheatersShowingMovie, _data, _reply, 0);
_reply.readException();
_result = _reply.createTypedArrayList(org.metasyntactic.data.Theater.CREATOR);
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.util.List<org.metasyntactic.data.Movie> getMoviesAtTheater(org.metasyntactic.data.Theater theater) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.util.List<org.metasyntactic.data.Movie> _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((theater!=null)) {
_data.writeInt(1);
theater.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getMoviesAtTheater, _data, _reply, 0);
_reply.readException();
_result = _reply.createTypedArrayList(org.metasyntactic.data.Movie.CREATOR);
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.util.List<org.metasyntactic.data.Performance> getPerformancesForMovieAtTheater(org.metasyntactic.data.Movie movie, org.metasyntactic.data.Theater theater) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.util.List<org.metasyntactic.data.Performance> _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
if ((theater!=null)) {
_data.writeInt(1);
theater.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getPerformancesForMovieAtTheater, _data, _reply, 0);
_reply.readException();
_result = _reply.createTypedArrayList(org.metasyntactic.data.Performance.CREATOR);
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.lang.String getScoreType() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getScoreType, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void setScoreType(java.lang.String scoreType) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeString(scoreType);
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
public byte[] getPoster(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
byte[] _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getPoster, _data, _reply, 0);
_reply.readException();
_result = _reply.createByteArray();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.lang.String getPosterFile_safeToCallFromBackground(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getPosterFile_safeToCallFromBackground, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.lang.String getSynopsis(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getSynopsis, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void prioritizeMovie(org.metasyntactic.data.Movie movie) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((movie!=null)) {
_data.writeInt(1);
movie.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_prioritizeMovie, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public boolean isAutoUpdateEnabled() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
boolean _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_isAutoUpdateEnabled, _data, _reply, 0);
_reply.readException();
_result = (0!=_reply.readInt());
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void setAutoUpdateEnabled(boolean enabled) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(((enabled)?(1):(0)));
mRemote.transact(Stub.TRANSACTION_setAutoUpdateEnabled, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public long getSearchDate() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
long _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getSearchDate, _data, _reply, 0);
_reply.readException();
_result = _reply.readLong();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void setSearchDate(long date) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeLong(date);
mRemote.transact(Stub.TRANSACTION_setSearchDate, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public java.util.List<org.metasyntactic.data.Movie> getUpcomingMovies() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.util.List<org.metasyntactic.data.Movie> _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getUpcomingMovies, _data, _reply, 0);
_reply.readException();
_result = _reply.createTypedArrayList(org.metasyntactic.data.Movie.CREATOR);
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.lang.String getDataProviderState() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getDataProviderState, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public boolean isStale(org.metasyntactic.data.Theater theater) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
boolean _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((theater!=null)) {
_data.writeInt(1);
theater.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_isStale, _data, _reply, 0);
_reply.readException();
_result = (0!=_reply.readInt());
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public java.lang.String getShowtimesRetrievedOnString(org.metasyntactic.data.Theater theater) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((theater!=null)) {
_data.writeInt(1);
theater.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_getShowtimesRetrievedOnString, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
public void addFavoriteTheater(org.metasyntactic.data.Theater theater) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((theater!=null)) {
_data.writeInt(1);
theater.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_addFavoriteTheater, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public void removeFavoriteTheater(org.metasyntactic.data.Theater theater) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((theater!=null)) {
_data.writeInt(1);
theater.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_removeFavoriteTheater, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
public boolean isFavoriteTheater(org.metasyntactic.data.Theater theater) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
boolean _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((theater!=null)) {
_data.writeInt(1);
theater.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
mRemote.transact(Stub.TRANSACTION_isFavoriteTheater, _data, _reply, 0);
_reply.readException();
_result = (0!=_reply.readInt());
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
}
static final int TRANSACTION_getUserAddress = (IBinder.FIRST_CALL_TRANSACTION + 0);
static final int TRANSACTION_setUserAddress = (IBinder.FIRST_CALL_TRANSACTION + 1);
static final int TRANSACTION_getLocationForAddress = (IBinder.FIRST_CALL_TRANSACTION + 2);
static final int TRANSACTION_getSearchDistance = (IBinder.FIRST_CALL_TRANSACTION + 3);
static final int TRANSACTION_setSearchDistance = (IBinder.FIRST_CALL_TRANSACTION + 4);
static final int TRANSACTION_getSelectedTabIndex = (IBinder.FIRST_CALL_TRANSACTION + 5);
static final int TRANSACTION_setSelectedTabIndex = (IBinder.FIRST_CALL_TRANSACTION + 6);
static final int TRANSACTION_getAllMoviesSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 7);
static final int TRANSACTION_setAllMoviesSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 8);
static final int TRANSACTION_getAllTheatersSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 9);
static final int TRANSACTION_setAllTheatersSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 10);
static final int TRANSACTION_getUpcomingMoviesSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 11);
static final int TRANSACTION_setUpcomingMoviesSelectedSortIndex = (IBinder.FIRST_CALL_TRANSACTION + 12);
static final int TRANSACTION_getMovies = (IBinder.FIRST_CALL_TRANSACTION + 13);
static final int TRANSACTION_getTheaters = (IBinder.FIRST_CALL_TRANSACTION + 14);
static final int TRANSACTION_getTrailer = (IBinder.FIRST_CALL_TRANSACTION + 15);
static final int TRANSACTION_getReviews = (IBinder.FIRST_CALL_TRANSACTION + 16);
static final int TRANSACTION_getAmazonAddress = (IBinder.FIRST_CALL_TRANSACTION + 17);
static final int TRANSACTION_getIMDbAddress = (IBinder.FIRST_CALL_TRANSACTION + 18);
static final int TRANSACTION_getWikipediaAddress = (IBinder.FIRST_CALL_TRANSACTION + 19);
static final int TRANSACTION_getTheatersShowingMovie = (IBinder.FIRST_CALL_TRANSACTION + 20);
static final int TRANSACTION_getMoviesAtTheater = (IBinder.FIRST_CALL_TRANSACTION + 21);
static final int TRANSACTION_getPerformancesForMovieAtTheater = (IBinder.FIRST_CALL_TRANSACTION + 22);
static final int TRANSACTION_getScoreType = (IBinder.FIRST_CALL_TRANSACTION + 23);
static final int TRANSACTION_setScoreType = (IBinder.FIRST_CALL_TRANSACTION + 24);
static final int TRANSACTION_getScore = (IBinder.FIRST_CALL_TRANSACTION + 25);
static final int TRANSACTION_getPoster = (IBinder.FIRST_CALL_TRANSACTION + 26);
static final int TRANSACTION_getPosterFile_safeToCallFromBackground = (IBinder.FIRST_CALL_TRANSACTION + 27);
static final int TRANSACTION_getSynopsis = (IBinder.FIRST_CALL_TRANSACTION + 28);
static final int TRANSACTION_prioritizeMovie = (IBinder.FIRST_CALL_TRANSACTION + 29);
static final int TRANSACTION_isAutoUpdateEnabled = (IBinder.FIRST_CALL_TRANSACTION + 30);
static final int TRANSACTION_setAutoUpdateEnabled = (IBinder.FIRST_CALL_TRANSACTION + 31);
static final int TRANSACTION_getSearchDate = (IBinder.FIRST_CALL_TRANSACTION + 32);
static final int TRANSACTION_setSearchDate = (IBinder.FIRST_CALL_TRANSACTION + 33);
static final int TRANSACTION_getUpcomingMovies = (IBinder.FIRST_CALL_TRANSACTION + 34);
static final int TRANSACTION_getDataProviderState = (IBinder.FIRST_CALL_TRANSACTION + 35);
static final int TRANSACTION_isStale = (IBinder.FIRST_CALL_TRANSACTION + 36);
static final int TRANSACTION_getShowtimesRetrievedOnString = (IBinder.FIRST_CALL_TRANSACTION + 37);
static final int TRANSACTION_addFavoriteTheater = (IBinder.FIRST_CALL_TRANSACTION + 38);
static final int TRANSACTION_removeFavoriteTheater = (IBinder.FIRST_CALL_TRANSACTION + 39);
static final int TRANSACTION_isFavoriteTheater = (IBinder.FIRST_CALL_TRANSACTION + 40);
}
public java.lang.String getUserAddress() throws android.os.RemoteException;
public void setUserAddress(java.lang.String address) throws android.os.RemoteException;
public org.metasyntactic.data.Location getLocationForAddress(java.lang.String address) throws android.os.RemoteException;
public int getSearchDistance() throws android.os.RemoteException;
public void setSearchDistance(int distance) throws android.os.RemoteException;
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
public java.lang.String getTrailer(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public java.util.List<org.metasyntactic.data.Review> getReviews(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public java.lang.String getAmazonAddress(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public java.lang.String getIMDbAddress(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public java.lang.String getWikipediaAddress(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public java.util.List<org.metasyntactic.data.Theater> getTheatersShowingMovie(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public java.util.List<org.metasyntactic.data.Movie> getMoviesAtTheater(org.metasyntactic.data.Theater theater) throws android.os.RemoteException;
public java.util.List<org.metasyntactic.data.Performance> getPerformancesForMovieAtTheater(org.metasyntactic.data.Movie movie, org.metasyntactic.data.Theater theater) throws android.os.RemoteException;
public java.lang.String getScoreType() throws android.os.RemoteException;
public void setScoreType(java.lang.String scoreType) throws android.os.RemoteException;
public org.metasyntactic.data.Score getScore(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public byte[] getPoster(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public java.lang.String getPosterFile_safeToCallFromBackground(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public java.lang.String getSynopsis(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public void prioritizeMovie(org.metasyntactic.data.Movie movie) throws android.os.RemoteException;
public boolean isAutoUpdateEnabled() throws android.os.RemoteException;
public void setAutoUpdateEnabled(boolean enabled) throws android.os.RemoteException;
public long getSearchDate() throws android.os.RemoteException;
public void setSearchDate(long date) throws android.os.RemoteException;
public java.util.List<org.metasyntactic.data.Movie> getUpcomingMovies() throws android.os.RemoteException;
public java.lang.String getDataProviderState() throws android.os.RemoteException;
public boolean isStale(org.metasyntactic.data.Theater theater) throws android.os.RemoteException;
public java.lang.String getShowtimesRetrievedOnString(org.metasyntactic.data.Theater theater) throws android.os.RemoteException;
public void addFavoriteTheater(org.metasyntactic.data.Theater theater) throws android.os.RemoteException;
public void removeFavoriteTheater(org.metasyntactic.data.Theater theater) throws android.os.RemoteException;
public boolean isFavoriteTheater(org.metasyntactic.data.Theater theater) throws android.os.RemoteException;
}
