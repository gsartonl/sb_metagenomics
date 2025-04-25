# python functions
import os
def get_lanes_for_batch(library):
    """ 
    Function to get the appropriate lanes for each library.
    """
    library_data = config['metadata'][library]
    lanes = library_data['lanes']  # This should be a list of lane numbers like [2], [1, 2], or [6, 7]
    return lanes

def GetPaired_input(wildcards) :
    """ 
    Get paired reads files for reads filtering
    """
    fwd = pathRaw+"/"+wildcards.LIBRARY+"_L"+wildcards.LANE+"_R1_001_"+config['metadata'][wildcards.LIBRARY]['lane_data'][int(wildcards.LANE)]['Hash_FWD']+".fastq.gz"
    rev = pathRaw+"/"+wildcards.LIBRARY+"_L"+wildcards.LANE+"_R2_001_"+config['metadata'][wildcards.LIBRARY]['lane_data'][int(wildcards.LANE)]['Hash_REV']+".fastq.gz"
    return [fwd , rev]

def merge_readsFWD_input(wildcards) :
    """ 
    Get paired reads files for reads for mergin with the associated lanes
    """
    library_data = config['metadata'][wildcards.LIBRARY]
    lanes = library_data["lanes"]


    if len(lanes) == 1 :
        LANES = [2]
    else :
        LANES = lanes

    merge_dict = {
        'pathToFWD': [pathTrimmed + f"/{wildcards.LIBRARY}_L{LANE}_val_1.fq.gz" for LANE in LANES],
        'pathToREV': [pathTrimmed + f"/{wildcards.LIBRARY}_L{LANE}_val_2.fq.gz" for LANE in LANES]
    }
    return merge_dict # dict key:input_name val:path

def check_file_exists(filepath):
    #used in
    if not os.path.isfile(filepath):
        raise FileNotFoundError(f"File not found: {filepath}")