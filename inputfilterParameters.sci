loadXcosLibs;

// Define a function that generates filter blocks with user-defined parameters
function [x, y, typ] = FilterBlock(job, arg1, arg2, filter_type)
    x = [];
    y = [];
    typ = [];

    select job
        case 'set' then
            x = arg1;
            // Display dialog for setting parameters
            params = x_dialog("Set Filter Parameters", ..
                list("Sampling Frequency (Hz)", "Cutoff Frequency (Hz)", "Upper Cutoff (for Band filters)"), ..
                list("100", "10", "15"));
            // Updating the model parameters based on user input
            if ~isempty(params) then
                x.model.ipar = [evstr(params(1)), evstr(params(2)), evstr(params(3)), filter_type];
            end

        case 'define' then
            // Set up the model
            model = scicos_model();
            model.sim = list('filter_block', 4);
            model.blocktype = 'c';
            model.in = [1];
            model.out = [1];
            model.ipar = [100, 10, 15, filter_type]; // Default values for Sampling frequency, Cutoff frequencies, and Filter type
            model.rpar = [];
            model.evtin = [];
            model.evtout = [];
            model.pout = 2;
            model.dstate = [];
            x = standard_define([2 2], model, [], []);

            // Setting the block name based on filter type
            select filter_type
                case 1 then x.model.orig = "Low Pass Filter";
                case 2 then x.model.orig = "High Pass Filter";
                case 3 then x.model.orig = "Band Pass Filter";
                case 4 then x.model.orig = "Band Stop Filter";
            end
    end


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
endfunction



// Define functions for each filter type, setting filter_type value (1 = Low-pass, 2 = High-pass, 3 = Band-pass, 4 = Band-stop)
function [x, y, typ] = LowPassFilter(job)
    [x, y, typ] = FilterBlock(job, [], [], 1);
endfunction

function [x, y, typ] = HighPassFilter(job)
    [x, y, typ] = FilterBlock(job, [], [], 2);
endfunction

function [x, y, typ] = BandPassFilter(job)
    [x, y, typ] = FilterBlock(job, [], [], 3);
endfunction

function [x, y, typ] = BandStopFilter(job)
    [x, y, typ] = FilterBlock(job, [], [], 4);
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

// Create a new palette and add each filter block with proper names
pal = xcosPal("My Filters");
pal = xcosPalAddBlock(pal, lowPass, SCI + "/modules/xcos/images/palettes/RAMP.png", style);
pal = xcosPalAddBlock(pal, highPass, SCI + "/modules/xcos/images/palettes/RAMP.png", style);
pal = xcosPalAddBlock(pal, bandPass, SCI + "/modules/xcos/images/palettes/RAMP.png", style);
pal = xcosPalAddBlock(pal, bandStop, SCI + "/modules/xcos/images/palettes/RAMP.png", style);


xcosPalAdd(pal);
