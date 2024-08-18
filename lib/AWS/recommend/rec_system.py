import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from collections import Counter
import datetime
import json

class LeetCodeRecommender:
    def __init__(self):
        self.users = {}
        self.topics = set([
            'Arrays', 'Strings', 'Hash Table', 'Dynamic Programming', 'Math',
            'Sorting', 'Greedy', 'Depth-First Search', 'Binary Search', 'Database',
            'Breadth-First Search', 'Tree', 'Matrix', 'Two Pointers', 'Binary Tree',
            'Bit Manipulation', 'Heap', 'Stack', 'Graph', 'Prefix Sum',
            'Simulation', 'Design', 'Counting', 'Backtracking', 'Sliding Window',
            'Union Find', 'Linked List', 'Ordered Set', 'Monotonic Stack', 'Recursion',
            'Divide and Conquer', 'Trie', 'Binary Search Tree', 'Queue', 'Memoization',
            'Topological Sort', 'Segment Tree', 'Binary Indexed Tree', 'Game Theory',
            'Data Structure', 'Algorithm', 'TypeScript', 'JavaScript', 'Python', 'Java',
            'C++', 'C#', 'Go', 'Ruby', 'Swift', 'Kotlin', 'Rust', 'PHP', 'Scala',
            'System Design', 'Object-Oriented Design', 'React', 'Angular', 'Vue.js',
            'Node.js', 'Django', 'Flask', 'Spring', 'Express.js', 'Machine Learning',
            'Artificial Intelligence', 'Data Science', 'Big Data', 'Cloud Computing',
            'DevOps', 'Microservices', 'Blockchain', 'Cybersecurity', 'Mobile Development',
            'Web Development', 'Game Development', 'Embedded Systems', 'Computer Networks',
            'Operating Systems', 'Compiler Design', 'Computer Architecture'
        ])
        self.journeys = set([
            '10 Essential DP Patterns', '30 Days of JavaScript',
            'Programming Skills', 'Algorithm I', 'Algorithm II',
            'Data Structure I', 'Data Structure II', 'Graph Theory I',
            'Binary Search I', 'Binary Search II', 'SQL I', 'SQL II',
            'System Design', 'Object-Oriented Design', 'Machine Learning 101',
            'Dynamic Programming I', 'Stack I', 'Heap I', 'Tree I',
            'Advanced Algorithms', 'Operating Systems Fundamentals',
            'Computer Networks Basics', 'Web Development Bootcamp',
            'Mobile App Development', 'Cloud Computing Essentials',
            'Cybersecurity Fundamentals', 'Data Science Primer',
            'Artificial Intelligence Concepts', 'Blockchain Basics',
            'DevOps Practices', 'Microservices Architecture',
            'Front-end Frameworks', 'Back-end Development',
            'Database Design and Management', 'RESTful API Design',
            'Concurrency and Parallelism', 'Functional Programming',
            'Software Testing and QA', 'Agile Methodologies',
            'Big Data Processing', 'Natural Language Processing',
            'Computer Vision Fundamentals', 'Quantum Computing Primer'
        ])
        self.topic_matrix = None
        self.journey_matrix = None
        self.difficulty_levels = ['Beginner', 'Intermediate', 'Advanced']

    def add_user(self, user_id, preferences):
        preferences['topics'] = set(preferences['topics'])
        preferences['journey'] = set(preferences['journey'])
        preferences['last_active'] = datetime.datetime.now()
        self.users[user_id] = preferences
        self.topics.update(preferences['topics'])
        self.journeys.update(preferences['journey'])

    def build_matrices(self):
        n_users = len(self.users)
        n_topics = len(self.topics)
        n_journeys = len(self.journeys)

        self.topic_matrix = np.zeros((n_users, n_topics))
        self.journey_matrix = np.zeros((n_users, n_journeys))

        topic_index = {topic: i for i, topic in enumerate(self.topics)}
        journey_index = {journey: i for i, journey in enumerate(self.journeys)}

        for i, (user_id, prefs) in enumerate(self.users.items()):
            for topic in prefs['topics']:
                self.topic_matrix[i, topic_index[topic]] = 1
            for journey in prefs['journey']:
                self.journey_matrix[i, journey_index[journey]] = 1

    def calculate_time_decay(self, last_active):
        days_since_active = (datetime.datetime.now() - last_active).days
        return np.exp(-days_since_active / 30)  # 30-day half-life

    def recommend(self, user_id, n_recommendations=5):
        if user_id not in self.users:
            return "User not found"

        user_index = list(self.users.keys()).index(user_id)
        user_prefs = self.users[user_id]

        time_decay = self.calculate_time_decay(user_prefs['last_active'])
        topic_similarities = cosine_similarity(self.topic_matrix[user_index:user_index+1], self.topic_matrix)[0] * time_decay
        journey_similarities = cosine_similarity(self.journey_matrix[user_index:user_index+1], self.journey_matrix)[0] * time_decay

        combined_similarities = 0.6 * topic_similarities + 0.4 * journey_similarities

        similar_users = sorted(
            [(i, score) for i, score in enumerate(combined_similarities) if i != user_index],
            key=lambda x: x[1],
            reverse=True
        )[:n_recommendations]

        recommendations = {
            'topics': Counter(),
            'journeys': Counter(),
            'explanations': []
        }

        for similar_user_index, similarity_score in similar_users:
            similar_user_id = list(self.users.keys())[similar_user_index]
            similar_user_prefs = self.users[similar_user_id]

            new_topics = set(similar_user_prefs['topics']) - set(user_prefs['topics'])
            new_journeys = set(similar_user_prefs['journey']) - set(user_prefs['journey'])

            for topic in new_topics:
                recommendations['topics'][topic] += similarity_score
            for journey in new_journeys:
                recommendations['journeys'][journey] += similarity_score

            if new_topics or new_journeys:
                explanation = f"Based on similarity with user (score: {similarity_score:.2f}):"
                if new_topics:
                    explanation += f" Recommended topics: {', '.join(new_topics)}."
                if new_journeys:
                    explanation += f" Recommended journeys: {', '.join(new_journeys)}."
                recommendations['explanations'].append(explanation)
                
        user_difficulty = self.difficulty_levels.index(user_prefs['skillLevel'])
        for topic in self.topics - set(user_prefs['topics']):
            if topic in ['Data Structure', 'Algorithm'] and user_difficulty < 2:
                recommendations['topics'][topic] += 1
                recommendations['explanations'].append(f"Recommended {topic} based on your skill level.")

        for journey in self.journeys - set(user_prefs['journey']):
            if 'Beginner' in journey and user_difficulty == 0:
                recommendations['journeys'][journey] += 1
                recommendations['explanations'].append(f"Recommended {journey} based on your beginner skill level.")
            elif 'Advanced' in journey and user_difficulty == 2:
                recommendations['journeys'][journey] += 1
                recommendations['explanations'].append(f"Recommended {journey} based on your advanced skill level.")

        return {
            'recommended_topics': [topic for topic, _ in recommendations['topics'].most_common(n_recommendations)],
            'recommended_journeys': [journey for journey, _ in recommendations['journeys'].most_common(n_recommendations)],
            'explanations': recommendations['explanations'][:n_recommendations]
        }

    def provide_feedback(self, user_id, topic=None, journey=None, rating=None):
        if user_id not in self.users:
            return "User not found"

        if topic:
            self.users[user_id]['topics'].add(topic)
        if journey:
            self.users[user_id]['journey'].add(journey)
        
        self.users[user_id]['last_active'] = datetime.datetime.now()

        if rating:
            pass

        self.build_matrices()

        return "Feedback recorded successfully"

# Example usage
recommender = LeetCodeRecommender()

# Adding 20 users with diverse preferences
users_data = [
    ('user1', {'reason': 'learn', 'skillLevel': 'Intermediate', 'topics': ['Dynamic Programming', 'Database', 'Arrays'], 'journey': ['10 Essential DP Patterns', 'SQL I']}),
    ('user2', {'reason': 'interview', 'skillLevel': 'Advanced', 'topics': ['System Design', 'Data Structure', 'Algorithms', 'Graph'], 'journey': ['Programming Skills', 'Algorithm II']}),
    ('user3', {'reason': 'learn', 'skillLevel': 'Beginner', 'topics': ['TypeScript', 'React', 'JavaScript'], 'journey': ['30 Days of JavaScript', 'Front-end Frameworks']}),
    ('user4', {'reason': 'hobby', 'skillLevel': 'Intermediate', 'topics': ['Machine Learning', 'Python', 'Data Science'], 'journey': ['Machine Learning 101', 'Data Science Primer']}),
    ('user5', {'reason': 'career', 'skillLevel': 'Advanced', 'topics': ['Microservices', 'DevOps', 'Cloud Computing'], 'journey': ['System Design', 'Microservices Architecture']}),
    ('user6', {'reason': 'learn', 'skillLevel': 'Beginner', 'topics': ['Java', 'Object-Oriented Design', 'Data Structure'], 'journey': ['Data Structure I', 'Object-Oriented Design']}),
    ('user7', {'reason': 'interview', 'skillLevel': 'Intermediate', 'topics': ['C++', 'Binary Search', 'Dynamic Programming'], 'journey': ['Binary Search I', 'Dynamic Programming I']}),
    ('user8', {'reason': 'career', 'skillLevel': 'Advanced', 'topics': ['Blockchain', 'Cryptography', 'Smart Contracts'], 'journey': ['Blockchain Basics', 'Advanced Algorithms']}),
    ('user9', {'reason': 'hobby', 'skillLevel': 'Beginner', 'topics': ['Web Development', 'HTML', 'CSS'], 'journey': ['Web Development Bootcamp', '30 Days of JavaScript']}),
    ('user10', {'reason': 'learn', 'skillLevel': 'Intermediate', 'topics': ['Mobile Development', 'Swift', 'iOS'], 'journey': ['Mobile App Development', 'Programming Skills']}),
    ('user11', {'reason': 'career', 'skillLevel': 'Advanced', 'topics': ['Artificial Intelligence', 'Neural Networks', 'Computer Vision'], 'journey': ['Artificial Intelligence Concepts', 'Machine Learning 101']}),
    ('user12', {'reason': 'interview', 'skillLevel': 'Intermediate', 'topics': ['Database', 'SQL', 'NoSQL'], 'journey': ['SQL II', 'Database Design and Management']}),
    ('user13', {'reason': 'learn', 'skillLevel': 'Beginner', 'topics': ['Go', 'Concurrency', 'Web Services'], 'journey': ['Back-end Development', 'Concurrency and Parallelism']}),
    ('user14', {'reason': 'hobby', 'skillLevel': 'Advanced', 'topics': ['Game Development', 'Unity', 'C#'], 'journey': ['Game Development', 'Algorithm I']}),
    ('user15', {'reason': 'career', 'skillLevel': 'Intermediate', 'topics': ['Big Data', 'Hadoop', 'Spark'], 'journey': ['Big Data Processing', 'Data Science Primer']}),
    ('user16', {'reason': 'learn', 'skillLevel': 'Beginner', 'topics': ['Ruby', 'Ruby on Rails', 'Web Development'], 'journey': ['Web Development Bootcamp', 'Programming Skills']}),
    ('user17', {'reason': 'interview', 'skillLevel': 'Advanced', 'topics': ['Operating Systems', 'Distributed Systems', 'Computer Networks'], 'journey': ['Operating Systems Fundamentals', 'Computer Networks Basics']}),
    ('user18', {'reason': 'career', 'skillLevel': 'Intermediate', 'topics': ['Natural Language Processing', 'Python', 'NLTK'], 'journey': ['Natural Language Processing', 'Machine Learning 101']}),
    ('user19', {'reason': 'hobby', 'skillLevel': 'Beginner', 'topics': ['Arduino', 'Raspberry Pi', 'IoT'], 'journey': ['Embedded Systems', 'Programming Skills']}),
    ('user20', {'reason': 'learn', 'skillLevel': 'Advanced', 'topics': ['Quantum Computing', 'Linear Algebra', 'Quantum Algorithms'], 'journey': ['Quantum Computing Primer', 'Advanced Algorithms']}),
]

for user_id, preferences in users_data:
    recommender.add_user(user_id, preferences)
     
recommender.build_matrices()

def lambda_handler(event, context):
    try:
        user_preferences = event['preferences']
        user_id = f"user_{len(recommender.users) + 1}"
        recommender.add_user(user_id, user_preferences)
        recommender.build_matrices()
        recommendations = recommender.recommend(user_id)
        return {
            'statusCode': 200,
            'body': json.dumps(recommendations)
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }


