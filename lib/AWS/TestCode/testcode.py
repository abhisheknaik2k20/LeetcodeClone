class Solution:
    @staticmethod
    def generate_boilerplate(problem, language):
        title = problem['title']
        difficulty = problem['difficulty']
        content = problem['content']
        testcases = problem['testcases']

        # Generate function name
        func_name = '_'.join(title.lower().split())

        # Generate function signature
        params = set()
        for case in testcases:
            params.update(case.keys())
        params.discard('title')
        params.discard('output')
        params.discard('explain')

        if language == 'python':
            return Solution.generate_python(func_name, difficulty, content, testcases, params)
        elif language == 'cpp':
            return Solution.generate_cpp(func_name, difficulty, content, testcases, params)
        elif language == 'java':
            return Solution.generate_java(func_name, difficulty, content, testcases, params)
        else:
            return "Unsupported language"

    @staticmethod
    def generate_python(func_name, difficulty, content, testcases, params):
        param_list = ', '.join(params)
        
        boilerplate = f"""class Solution:
    def {func_name}(self, {param_list}):
        \"\"\"
        {difficulty}
        
        Problem description:
        {''.join(item['text'] for item in content if 'text' in item)}
        
        Example:
        Input: {testcases[0]['input']}
        Output: {testcases[0]['output']}
        Explanation: {testcases[0]['explain']}
        \"\"\"
        # Your code here
        pass

# Test cases
def test_{func_name}():
    solution = Solution()
    
    # Test cases
"""

        for i, case in enumerate(testcases, 1):
            inputs = ', '.join(f"{k}={v}" for k, v in case.items() if k not in ['title', 'output', 'explain'])
            boilerplate += f"""    assert solution.{func_name}({inputs}) == {case['output']}, "Test case {i} failed"
"""

        boilerplate += f"\n    print('All test cases passed!')\n\ntest_{func_name}()"

        return boilerplate

    @staticmethod
    def generate_cpp(func_name, difficulty, content, testcases, params):
        param_list = ', '.join(f"vector<int>& {p}" if p == 'input' else f"int {p}" for p in params)
        
        boilerplate = f"""#include <vector>
#include <cassert>
#include <iostream>

using namespace std;

class Solution {{
public:
    /*
    {difficulty}
    
    Problem description:
    {''.join(item['text'] for item in content if 'text' in item)}
    
    Example:
    Input: {testcases[0]['input']}
    Output: {testcases[0]['output']}
    Explanation: {testcases[0]['explain']}
    */
    vector<int> {func_name}({param_list}) {{
        // Your code here
        return vector<int>();
    }}
}};

// Test cases
void test_{func_name}() {{
    Solution solution;
    
    // Test cases
"""

        for i, case in enumerate(testcases, 1):
            inputs = ', '.join(str(case[k]) for k in params)
            boilerplate += f"""    assert(solution.{func_name}({inputs}) == vector<int>{{{', '.join(map(str, case['output']))}}});
"""

        boilerplate += f"""
    cout << "All test cases passed!" << endl;
}}

int main() {{
    test_{func_name}();
    return 0;
}}"""

        return boilerplate

    @staticmethod
    def generate_java(func_name, difficulty, content, testcases, params):
        param_list = ', '.join(f"int[] {p}" if p == 'input' else f"int {p}" for p in params)
        
        boilerplate = f"""import java.util.Arrays;

class Solution {{
    /*
    {difficulty}
    
    Problem description:
    {''.join(item['text'] for item in content if 'text' in item)}
    
    Example:
    Input: {testcases[0]['input']}
    Output: {testcases[0]['output']}
    Explanation: {testcases[0]['explain']}
    */
    public int[] {func_name}({param_list}) {{
        // Your code here
        return new int[]{{}};
    }}

    // Test cases
    public static void main(String[] args) {{
        Solution solution = new Solution();
        
        // Test cases
"""

        for i, case in enumerate(testcases, 1):
            inputs = ', '.join(f"new int[]{{{', '.join(map(str, case['input']))}}}" if k == 'input' else str(case[k]) for k in params)
            boilerplate += f"""        assert Arrays.equals(solution.{func_name}({inputs}), new int[]{{{', '.join(map(str, case['output']))}}});
"""

        boilerplate += f"""
        System.out.println("All test cases passed!");
    }}
}}"""

        return boilerplate

# Example usage:
problem = {
    id: '5',
    "title": "Longest Palindromic Substring",
    "status": "Unsolved",
    "acceptanceRate": 31.2,
    "difficulty": "Medium",
    "frequency": "High",
    "content": [
      {
        'text': 'Longest Palindromic Substring\n\n',
        'fontSize': 24,
        'isBold': "true"
      },
      {'text': 'Medium\n\n', 'color': 'orange', 'isBold': "true"},
      {
        'text':
            'Given a string s, return the longest palindromic substring in s.\n\n'
      },
      {'text': 'Constraints:\n', 'isBold': "true"},
      {'text': '• 1 <= s.length <= 1000\n'},
      {'text': '• s consist of only digits and English letters.\n'},
    ],
    "testcases": [
      {
        'title': 'Test Case 1',
        'input': "babad",
        'output': "bab",
        'explain': '"aba" is also a valid answer.'
      },
      {
        'title': 'Test Case 2',
        'input': "cbbd",
        'output': "bb",
        'explain': 'The answer is "bb".'
      },
      {
        'title': 'Test Case 3',
        'input': "a",
        'output': "a",
        'explain': 'The answer is "a".'
      },
    ],
}

print("Python:\n")
print(Solution.generate_boilerplate(problem, 'python'))
print("\n\nC++:\n")
print(Solution.generate_boilerplate(problem, 'cpp'))
print("\n\nJava:\n")
print(Solution.generate_boilerplate(problem, 'java'))