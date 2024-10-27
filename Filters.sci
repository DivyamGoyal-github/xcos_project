loadXcosLibs;

// Define the custom low-pass filter block
function [x, y, typ] = LowPassFilter(job, arg1, arg2)
    x = [];
    y = [];
    typ = [];
    
    select job
        case 'set' then
            x = arg1;
            messagebox('No settings for a Low-Pass Filter block type');
        case 'define' then
            model = scicos_model();
            model.sim = list('filter_block', 4); // Link to the filter function
            model.blocktype = 'c';
            model.in = [1];
            model.out = [1];
            model.ipar = [100, 10, 1]; // Sampling frequency, cutoff, filter type (1 = Low-pass)
            model.pout = 2;
            x = standard_define([2 2], model, [], []);
    end
endfunction

// Define the custom high-pass filter block
function [x, y, typ] = HighPassFilter(job, arg1, arg2)
    x = [];
    y = [];
    typ = [];
    
    select job
        case 'set' then
            x = arg1;
            messagebox('No settings for a High-Pass Filter block type');
        case 'define' then
            model = scicos_model();
            model.sim = list('filter_block', 4); // Link to the filter function
            model.blocktype = 'c';
            model.in = [1];
            model.out = [1];
            model.ipar = [100, 10, 2]; // Sampling frequency, cutoff, filter type (2 = High-pass)
            model.pout = 2;
            x = standard_define([2 2], model, [], []);
    end
endfunction

// Define the custom band-pass filter block
function [x, y, typ] = BandPassFilter(job, arg1, arg2)
    x = [];
    y = [];
    typ = [];
    
    select job
        case 'set' then
            x = arg1;
            messagebox('No settings for a Band-Pass Filter block type');
        case 'define' then
            model = scicos_model();
            model.sim = list('filter_block', 4); // Link to the filter function
            model.blocktype = 'c';
            model.in = [1];
            model.out = [1];
            model.ipar = [100, 10, 15, 3]; // Sampling freq, lower & upper cutoffs, filter type (3 = Band-pass)
            model.pout = 2;
            x = standard_define([2 2], model, [], []);
    end
endfunction

// Define the custom band-stop filter block
function [x, y, typ] = BandStopFilter(job, arg1, arg2)
    x = [];
    y = [];
    typ = [];
    
    select job
        case 'set' then
            x = arg1;
            messagebox('No settings for a Band-Stop Filter block type');
        case 'define' then
            model = scicos_model();
            model.sim = list('filter_block', 4); // Link to the filter function
            model.blocktype = 'c';
            model.in = [1];
            model.out = [1];
            model.ipar = [100, 10, 15, 4]; // Sampling freq, lower & upper cutoffs, filter type (4 = Band-stop)
            model.pout = 2;
            x = standard_define([2 2], model, [], []);
    end
endfunction

// Simulation function that handles different filter types
function [y] = filter_block(t, u, model, in, out)
    fs = model.ipar(1); // Sampling frequency
    fc1 = model.ipar(2); // Cutoff or lower cutoff frequency
    fc2 = model.ipar(3); // Upper cutoff frequency (for band filters)
    filter_type = model.ipar(4); // Type of filter

    select filter_type
        case 1 then // Low-pass filter
            [b, a] = butter(2, fc1 / (fs / 2), 'low');
        case 2 then // High-pass filter
            [b, a] = butter(2, fc1 / (fs / 2), 'high');
        case 3 then // Band-pass filter
            [b, a] = butter(2, [fc1 fc2] / (fs / 2), 'bandpass');
        case 4 then // Band-stop filter
            [b, a] = butter(2, [fc1 fc2] / (fs / 2), 'stop');
    end

    y(1) = filter(b, a, u);
endfunction


style = struct();
style.fillColor = "red";
block_img = SCI + "/modules/xcos/images/blocks/RAMP.svg";
if getos() == "Windows" then
    block_img = "/" + block_img;
end
style.image = "file://" + block_img;


lowPass = LowPassFilter('define');
highPass = HighPassFilter('define');
bandPass = BandPassFilter('define');
bandStop = BandStopFilter('define');

// Create a new palette and add each block
pal = xcosPal("My Filters");
pal = xcosPalAddBlock(pal, lowPass, SCI + "/modules/xcos/images/palettes/RAMP.png", style);
pal = xcosPalAddBlock(pal, highPass, SCI + "/modules/xcos/images/palettes/RAMP.png", style);
pal = xcosPalAddBlock(pal, bandPass, SCI + "/modules/xcos/images/palettes/RAMP.png", style);
pal = xcosPalAddBlock(pal, bandStop, SCI + "/modules/xcos/images/palettes/RAMP.png", style);


xcosPalAdd(pal);
