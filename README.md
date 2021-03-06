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

* For triaxial data, calculate the Euclidean distance "scalar vector magnitude": sqrt(x^2 + y^2 + z^2) -- for audio, the mean of all channels.

* At 60 second intervals, slide a matching window (of 60 seconds) by the current search range

  * ...calculate the cross-correlation: storing the highest cross correlation coefficient and that lag amount (in samples)

* At analysis intervals (of 24 hours) find the best match local linearity (using the RANSAC regression; or the alternative method of eliminating outliers based on a median filter)

* Resample the dependent file to the line of best fit (interpolate between analysis intervals, extrapolate to fill any missing time points before)


## Return status codes

Return status codes:

| Name            | Value | Description                                                |
|:----------------|------:|:-----------------------------------------------------------|
| EXIT_OK         |     0 | Successful (all rates were valid)                          |
| EXIT_OK+1       |     1 | Partially successful (some, but not all, rates were valid) |
| EXIT_OK+2       |     2 | Not synchronized (no rates were valid)                     |
| EXIT_USAGE      |    64 | Command line usage error                                   |
| EXIT_DATAERR    |    65 | Data format error (e.g. input file cannot be parsed)       |
| EXIT_NOINPUT    |    66 | Cannot open input                                          |
| EXIT_SOFTWARE   |    70 | Internal software error                                    |
| EXIT_OSERR      |    71 | System error                                               |
| EXIT_CANTCREAT  |    73 | Can't create output file                                   |
| EXIT_IOERR      |    74 | Input/output error (e.g. an individual read/write failed)  |
| EXIT_CONFIG     |    78 | Configuration error                                        |


<!--
The minute-by-minute maximum correlation between the input files is calculated, with the lag: the time difference for that maximum correlation.  

For every 24-hour interval, a RANSAC regression is applied to find the best linear fit for clock offset and drift, but this is only valid when the conditions are met: at least 2% (analysisMinimumPointsProportion) of epochs must be considered then, based on the linear fit, at least 10% (analysisMinimumRangeProportion) of the points must be within range, where the range is defined as within 100ms (analysisMaxTime) of the line of best fit.

A return status of "2" means that none of these analyses produced a result that satisfied these conditions.  In other words, based on these parameters, it could not correct for clock offset or drift.
-->
