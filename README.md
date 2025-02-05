# Reed-Solomon Encoding and Decoding in MATLAB

This repository contains an implementation of Reed-Solomon encoding and decoding in MATLAB. The project includes tests and evaluations for the performance of the encoder/decoder under various conditions.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Encoding](#encoding)
  - [Decoding](#decoding)
- [Testing](#testing)
- [Evaluation](#evaluation)
- [Results](#results)
- [Contributing](#contributing)
- [License](#license)

## Installation

To use this project, you need to have MATLAB installed. No additional packages are required. Simply clone the repository and start using the provided functions.

```bash
git clone https://github.com/AmirhosseinChami/Coding_theory.git
```
## Usage
### Encoding 
You can use the RS_Enc.m function to encode a message using Reed-Solomon. You will need to provide the input message and other parameters like the codeword length and the error correction capability.
```bash 
encoded = RS_Enc(msg, m, prim_poly, n, k)
```
```input_message:``` The message to be encoded (in vector format).

```n:``` The codeword length (total length of the encoded message).

```k:``` The message length (length of the original message).

### Decoding
The ```RS_Dec.m``` function is used to decode the received message. 
```bash 
[decoded, error_pos, error_mag, g, S] = RS_Dec(encoded, m, prim_poly, n, k)
```
```received_message:``` The encoded message with possible errors (in vector format).

```n:``` The codeword length.

```k:``` The message length.
## Testing
To test the entire system, you can use the provided ```RS_implementation_Test.m``` script. This script encodes a message, introduces errors, and decodes it to check if the original message is recovered.

```RS_implementation_Test.m```

Run the test script to validate the encoder-decoder system and Make sure the encoding and decoding process works as expected for various error conditions.

## Evaluation
For evaluating the performance of the Reed-Solomon code, you can use the RS_evaluation.m script. 

```RS_evaluation.m```

This script models a system with an AWGN channel and QAM modulation, using MATLAB's built-in encoder/decoder. The script plots the BER vs. Eb/N0 curve.

## Results
Here are the results from the test and evaluation files:

RS_implementation_Test.m result:

![implementation_test](https://github.com/user-attachments/assets/bf39a9f1-5045-4dcf-8ac8-9b4c22d71309)

RS_evaluation.m result:

![RS_evaluation](https://github.com/user-attachments/assets/ea953100-b1df-4c20-b2c7-a8c16d292d6b)

## Contributing
Contributions are welcome! If you have any ideas, bug reports, or improvements, feel free to open an issue or submit a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.
