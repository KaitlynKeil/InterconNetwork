""" Generates a test bench """
import numpy as np

def generate1DtestBench(node_list, num_instructions):
	name_dict = {'000':'zero', '001':'one', '010':'two', '011':'three', '100':'four'}
	instr_list = []
	for instr in range(num_instructions):
		source_a, dest_a = np.random.choice(node_list, (2,1), replace = False)
		source = name_dict[source_a[0]]
		dest = dest_a[0][-3:]
		data_rest = ''.join([str(x[0]) for x in np.random.randint(2, size = (29,1))])
		instr_str = source+"InData = 32'b" + dest + data_rest + "; " + source+"InCS = 1'b1; #20"
		instr_list.append(instr_str)
		print(instr_str)
		cs_low_str = source + "InCS = 1'b0;"
		instr_list.append(cs_low_str)
		print(cs_low_str)
	return instr_list

def generate2DtestBench(node_list, num_instructions):
	name_dict = {'00000':'00', '00001':'01', '00010':'02',
				'01000':'10', '01001':'11', '01010':'12',
				'10000':'20', '10001':'21', '10010':'22',}
	instr_list = []
	for instr in range(num_instructions):
		source_a, dest_a = np.random.choice(node_list, (2,1), replace = False)
		source = name_dict[source_a[0]]
		dest = dest_a[0]
		data_rest = ''.join([str(x[0]) for x in np.random.randint(2, size = (27,1))])
		instr_str = 'fromOutTo'+source+"Data = 32'b" + dest + data_rest + "; " + 'fromOutTo'+source+"CS = 1'b1; #20"
		instr_list.append(instr_str)
		print(instr_str)
		cs_low_str = 'fromOutTo'+source+"CS= 1'b0;"
		instr_list.append(cs_low_str)
		print(cs_low_str)
	return instr_list

if __name__ == '__main__':
	# list_instructions = generate1DtestBench(["000","001","010","011","100"], 16)
	list_instructions = generate2DtestBench(["00000","00001","00010",
											"01000","01001","01010",
											"10000","10001","10010"], 4)

