// include stuff
#include "mex.h"
#include <string>
#include <iostream>
#include <sstream>
#include "stl_driver.h"

using namespace std;
using namespace CPSGrader;

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[] ) {


    stringstream fcout;
    
    if (nrhs<=1)
        mexErrMsgTxt("four inputs are expected: signal names, a formula (string), data (array), time interval (array of size 2).");
    
    /* read inputs: a string and data */
    char *signal_buf = mxArrayToString(prhs[0]);
    char *stl_buf = mxArrayToString(prhs[1]);   
    string phi_st = "signal "+ string(signal_buf) + "\n" + "phi:=" + string(stl_buf);
    
    size_t m = mxGetM(prhs[2]);
    size_t n=  mxGetN(prhs[2]);
    
    double *data_in = (double *) mxGetPr(prhs[2]);
    double *time_in = (double *) mxGetPr(prhs[3]);
    
    STLDriver stl_driver = STLDriver();
	
//     vector<double> sample;
//     for(int i = 0; i<n; i++){
//         for(int j = 0; j<m; j++) {
//             sample.push_back(data_in[j+ i*m]);
//         }
//         stl_driver.data.push_back(sample);
//         sample.clear();
//         //cout << endl;
//     }
    
    transducer * phi; 
    double rob, rob_up, rob_low;
    rob = rob_up = rob_low = 0;
     
    Signal z, z_up, z_low;
	bool parse_success = stl_driver.parse_string(phi_st);


    plhs[0] = mxCreateDoubleMatrix(1,n, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1,n, mxREAL);

    double *rob_up_ptr = mxGetPr(plhs[0]);
    double *rob_low_ptr = mxGetPr(plhs[1]);

    if (parse_success) {
		phi = stl_driver.formula_map["phi"]->clone();
        phi->set_horizon(time_in[0], time_in[1]);

        vector<double> sample;
        for(int i = 0; i < n; i++){
            for(int j = 0; j < m; j++){
                sample.push_back(data_in[j + i*m]);
            }
            stl_driver.data.push_back(sample);
            sample.clear();
            phi->set_trace_data_ptr(stl_driver.data);
            
            //cout << "Size of data:" <<        (phi->trace_data_ptr)->size() << endl;
    
            
            //rob    = phi->compute_robustness();
            cout<<"ready to get in"<<endl;
            rob_up = phi->compute_upper_rob();
            cout<<"up get out"<<rob_up<<endl;
            rob_low= phi->compute_lower_rob();
            cout<<"low get out"<<endl;
            rob_up_ptr[i] = rob_up;
            rob_low_ptr[i] = rob_low;
            
            //cout << "results" << rob <<" " << rob_up<< " " << rob_low <<endl;
        }
        
        z =  phi->z;
        z_low = phi->z_low;
        z_up = phi->z_up;
    }
    else
    	mexErrMsgTxt("Problem parsing formula.");


    // clean
    mxFree(signal_buf);
    mxFree(stl_buf);
    delete phi;
}


//
