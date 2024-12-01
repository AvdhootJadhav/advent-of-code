#include <bits/stdc++.h>
#include <fstream>

using namespace std;

void solve() {
	ifstream file("demo.txt");
	string str;
	
	vector<int> data, temp;
	vector<pair<int, vector<int>>> opcodes;
	
	while(getline(file, str)){
		string a = "";
		for(auto x: str){
			if (x == ','){
				data.push_back(stoi(a));
				a = "";
			} else {
				a += x;
			}
		}
	}
	
	temp = data;
	
	while(true){
		int noun = rand()%100;
		int verb = rand()%100;
		
		vector<int> pos;
		int op = -1;
		
		data[1] = noun;
		data[2] = verb;
		
		for(auto x: data){
			if(op == -1){
				op = x;
				continue;
			}
			if(pos.size() == 3){
				opcodes.push_back({op, pos});
				op = x;
				pos.clear();
			} else {
				pos.push_back(x);
			}
		}
		
		for(auto x: opcodes){
			auto y = x.second;
			if (x.first == 1){
				data[y[2]] = data[y[0]]+data[y[1]];
			}
			else{
				data[y[2]] = data[y[0]]*data[y[1]];
			}
		}
		
		if (data[0] == 19690720){
			cout<<100*noun+verb;
			break;
		}
		
		opcodes.clear();
		data = temp;
	}
}

int main() {
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
	solve();
}
