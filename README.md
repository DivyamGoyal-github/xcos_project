# xcos_project
Adding custom blocks to a custom pallete in xcos - a free alternative to simulink

## **README**

### **Creating Custom Filter Blocks in Xcos**

**Introduction**

This repository provides Xcos blocks for common filter types: low-pass, high-pass, band-pass, and band-stop. These blocks can be easily added to your Xcos palette and used in your simulations.

**Prerequisites:**

- Scilab installed on your system.

**Getting Started:**

1. **Clone the Repository:**
   - Clone this repository to your local machine using a Git client or the following command in your terminal:

     ```bash
     git clone "https://github.com/DivyamGoyal-github/xcos_project.git"
     ```

2. **Open Scilab:**
   - Launch Scilab on your system.

3. **Load the Script:**
   - In the Scilab console, navigate to the directory where you cloned the repository.
   - Execute the following command to load the script:
  

     ```scilab
     exec('Filters.sci');
     ```
     Alternatively, For giving custom user inputs to set the filter parameters you can execute the following file using the below command
     ```scilab
     exec('inputfilterParameters.sci');
     ```


4. **Use the Filters:**
   - Open Xcos.
   - You should now see the custom filter blocks in the "My Filters" palette.
   - Drag and drop the desired filter block onto your Xcos diagram.
   - Connect the input and output ports of the block to other blocks in your diagram.
   - Configure the filter parameters (e.g., cutoff frequency, sampling rate) by double-clicking on the block.

**How it Works:**

The provided script defines custom Xcos blocks for each filter type. The filter functions themselves are implemented using Scilab's signal processing toolbox. They take input signals and filter parameters (such as sampling frequency and cutoff frequency) as input and produce the filtered output.

**Additional Tips:**

- **Customize Parameters:** You can modify the default parameter values in the script function (.sci file) to suit your specific needs.
- **Explore Other Filter Types:** You can extend this approach to create other types of filters, such as notch filters or elliptic filters.
- **Optimize Performance:** For real-time applications, consider optimizing the filter implementation and using more efficient algorithms.
- **Experiment and Learn:** Don't be afraid to experiment with different filter parameters and configurations to achieve your desired results.

By following these steps, you can easily create custom filter blocks in Xcos and enhance your simulation capabilities.
