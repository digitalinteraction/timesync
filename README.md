# Time Series Data Synchronization

Open Movement One-Dimensional Long-term Time Series Data Synchronization

Long term (e.g. 7-day) accelerometer measurements (e.g. from multiple sites on the same body).

Local oscillators with different frequencies and stability (in ppm) cause drift.


## Usage

The code can be compiled for Linux, Windows (native and *Bash on Ubuntu on Windows*), and Mac (untested).  

Instructions for building from the repository in your terminal (for Windows native builds replace `make` with the `build` script):

```bash
git clone https://openlab.ncl.ac.uk/gitlab/dan.jackson/timesync
cd timesync/src/timesync
make
```

Alternatively, on Linux or Mac (*XCode* required), you can use this single line command to build a `timesync` binary in the current directory:

```bash
mkdir timesync.build; curl https://openlab.ncl.ac.uk/gitlab/dan.jackson/timesync/repository/master/archive.zip -o timesync.build/archive.zip; unzip timesync.build/archive.zip -d timesync.build; make -C timesync.build/timesync-*/src/timesync && cp timesync.build/timesync-*/src/timesync/timesync .
```

`timesync` requires `.WAV` files -- if you need to convert `.CWA` to `.WAV` files, first use `omconvert` (remove `./` if under Windows):

```bash
./omconvert master.cwa -out master.wav
./omconvert dependent.cwa -out dependent.wav
```

To use `timesync` itself (remove `./` if under Windows):

```bash
./timesync master.wav dependent.wav -out dependent.out.wav
```

Where:
* `master.wav` is the omconvert-ed .wav file of the master signal (the dependent will be synchronized to).
* `dependent.wav` is the omconvert-ed .wav file of the dependent signal (to be synchronized against the master).
* `dependent.out.wav` is the dependent .wav file resynchronized to match the master .wav file.


## Processing steps

For synchronization, choose a 'master' file (used as the reference) and a 'dependent' file (to be resampled to match).

For triaxial data, calculate the Euclidean distance "scalar vector magnitude": sqrt(x^2 + y^2 + z^2) -- for audio, the mean of all channels.

At 60 second intervals, slide a matching window (of 60 seconds) by the current search range
* ...calculate the cross-correlation: storing the highest cross correlation coefficient and that lag amount (in samples)

At analysis intervals (of 24 hours) find the best match local linearity (eliminate outliers based on a median filter)

Resample the dependent file to the line of best fit (interpolate between analysis intervals, extrapolate to fill any missing time points before)

