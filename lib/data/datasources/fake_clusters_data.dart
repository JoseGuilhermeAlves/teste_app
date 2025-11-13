const String fakeClustersJson = '''
{
  "clusters": [
    {
      "id": "1",
      "name": "Design Team",
      "description": "Creative minds shaping user experiences",
      "category": "Design",
      "memberCount": 8,
      "iconEmoji": "🎨",
      "colorHex": "#FF6B6B",
      "createdAt": "2024-01-15T10:30:00Z",
      "members": [
        {
          "id": "m1",
          "name": "Sarah Johnson",
          "role": "Lead Designer",
          "avatarUrl": "https://i.pravatar.cc/150?img=1",
          "isOnline": true,
          "joinedAt": "2024-01-15T10:30:00Z"
        },
        {
          "id": "m2",
          "name": "Mike Chen",
          "role": "UI Designer",
          "avatarUrl": "https://i.pravatar.cc/150?img=2",
          "isOnline": true,
          "joinedAt": "2024-01-20T14:20:00Z"
        },
        {
          "id": "m3",
          "name": "Emma Wilson",
          "role": "UX Researcher",
          "avatarUrl": "https://i.pravatar.cc/150?img=3",
          "isOnline": false,
          "joinedAt": "2024-02-01T09:15:00Z"
        },
        {
          "id": "m4",
          "name": "David Kim",
          "role": "Product Designer",
          "avatarUrl": "https://i.pravatar.cc/150?img=4",
          "isOnline": true,
          "joinedAt": "2024-02-10T11:00:00Z"
        },
        {
          "id": "m5",
          "name": "Lisa Anderson",
          "role": "Visual Designer",
          "avatarUrl": "https://i.pravatar.cc/150?img=5",
          "isOnline": false,
          "joinedAt": "2024-02-15T13:45:00Z"
        },
        {
          "id": "m6",
          "name": "Tom Martinez",
          "role": "Motion Designer",
          "avatarUrl": "https://i.pravatar.cc/150?img=6",
          "isOnline": true,
          "joinedAt": "2024-03-01T10:30:00Z"
        },
        {
          "id": "m7",
          "name": "Anna Lee",
          "role": "Graphic Designer",
          "avatarUrl": "https://i.pravatar.cc/150?img=7",
          "isOnline": true,
          "joinedAt": "2024-03-05T15:20:00Z"
        },
        {
          "id": "m8",
          "name": "Chris Brown",
          "role": "Illustrator",
          "avatarUrl": "https://i.pravatar.cc/150?img=8",
          "isOnline": false,
          "joinedAt": "2024-03-10T08:00:00Z"
        }
      ]
    },
    {
      "id": "2",
      "name": "Engineering",
      "description": "Building the future with code",
      "category": "Development",
      "memberCount": 12,
      "iconEmoji": "⚙️",
      "colorHex": "#4ECDC4",
      "createdAt": "2024-01-10T08:00:00Z",
      "members": [
        {
          "id": "m9",
          "name": "Alex Taylor",
          "role": "Tech Lead",
          "avatarUrl": "https://i.pravatar.cc/150?img=9",
          "isOnline": true,
          "joinedAt": "2024-01-10T08:00:00Z"
        },
        {
          "id": "m10",
          "name": "Jessica White",
          "role": "Senior Developer",
          "avatarUrl": "https://i.pravatar.cc/150?img=10",
          "isOnline": true,
          "joinedAt": "2024-01-12T09:30:00Z"
        },
        {
          "id": "m11",
          "name": "Ryan Garcia",
          "role": "Backend Engineer",
          "avatarUrl": "https://i.pravatar.cc/150?img=11",
          "isOnline": false,
          "joinedAt": "2024-01-15T10:00:00Z"
        },
        {
          "id": "m12",
          "name": "Sophie Turner",
          "role": "Frontend Developer",
          "avatarUrl": "https://i.pravatar.cc/150?img=12",
          "isOnline": true,
          "joinedAt": "2024-01-18T11:15:00Z"
        },
        {
          "id": "m13",
          "name": "Daniel Harris",
          "role": "DevOps Engineer",
          "avatarUrl": "https://i.pravatar.cc/150?img=13",
          "isOnline": true,
          "joinedAt": "2024-01-20T13:00:00Z"
        },
        {
          "id": "m14",
          "name": "Olivia Moore",
          "role": "Mobile Developer",
          "avatarUrl": "https://i.pravatar.cc/150?img=14",
          "isOnline": false,
          "joinedAt": "2024-01-25T14:30:00Z"
        },
        {
          "id": "m15",
          "name": "James Wilson",
          "role": "QA Engineer",
          "avatarUrl": "https://i.pravatar.cc/150?img=15",
          "isOnline": true,
          "joinedAt": "2024-02-01T09:00:00Z"
        },
        {
          "id": "m16",
          "name": "Emily Davis",
          "role": "Full Stack Developer",
          "avatarUrl": "https://i.pravatar.cc/150?img=16",
          "isOnline": true,
          "joinedAt": "2024-02-05T10:45:00Z"
        },
        {
          "id": "m17",
          "name": "Michael Brown",
          "role": "Database Admin",
          "avatarUrl": "https://i.pravatar.cc/150?img=17",
          "isOnline": false,
          "joinedAt": "2024-02-10T12:00:00Z"
        },
        {
          "id": "m18",
          "name": "Rachel Green",
          "role": "Security Engineer",
          "avatarUrl": "https://i.pravatar.cc/150?img=18",
          "isOnline": true,
          "joinedAt": "2024-02-15T08:30:00Z"
        },
        {
          "id": "m19",
          "name": "Kevin Lee",
          "role": "Cloud Architect",
          "avatarUrl": "https://i.pravatar.cc/150?img=19",
          "isOnline": true,
          "joinedAt": "2024-02-20T11:00:00Z"
        },
        {
          "id": "m20",
          "name": "Amanda Scott",
          "role": "API Developer",
          "avatarUrl": "https://i.pravatar.cc/150?img=20",
          "isOnline": false,
          "joinedAt": "2024-02-25T13:30:00Z"
        }
      ]
    },
    {
      "id": "3",
      "name": "Marketing Squad",
      "description": "Spreading the word and building brand presence",
      "category": "Marketing",
      "memberCount": 6,
      "iconEmoji": "📢",
      "colorHex": "#FFE66D",
      "createdAt": "2024-02-01T09:00:00Z",
      "members": [
        {
          "id": "m21",
          "name": "Nicole Adams",
          "role": "Marketing Director",
          "avatarUrl": "https://i.pravatar.cc/150?img=21",
          "isOnline": true,
          "joinedAt": "2024-02-01T09:00:00Z"
        },
        {
          "id": "m22",
          "name": "Brandon Hall",
          "role": "Content Creator",
          "avatarUrl": "https://i.pravatar.cc/150?img=22",
          "isOnline": true,
          "joinedAt": "2024-02-05T10:30:00Z"
        },
        {
          "id": "m23",
          "name": "Victoria Price",
          "role": "Social Media Manager",
          "avatarUrl": "https://i.pravatar.cc/150?img=23",
          "isOnline": false,
          "joinedAt": "2024-02-10T11:00:00Z"
        },
        {
          "id": "m24",
          "name": "Justin Clark",
          "role": "SEO Specialist",
          "avatarUrl": "https://i.pravatar.cc/150?img=24",
          "isOnline": true,
          "joinedAt": "2024-02-15T14:00:00Z"
        },
        {
          "id": "m25",
          "name": "Samantha King",
          "role": "Brand Manager",
          "avatarUrl": "https://i.pravatar.cc/150?img=25",
          "isOnline": true,
          "joinedAt": "2024-02-20T09:30:00Z"
        },
        {
          "id": "m26",
          "name": "Eric Wright",
          "role": "Growth Hacker",
          "avatarUrl": "https://i.pravatar.cc/150?img=26",
          "isOnline": false,
          "joinedAt": "2024-02-25T12:00:00Z"
        }
      ]
    },
    {
      "id": "4",
      "name": "Product Strategy",
      "description": "Defining vision and roadmap for success",
      "category": "Product",
      "memberCount": 5,
      "iconEmoji": "🎯",
      "colorHex": "#A8E6CF",
      "createdAt": "2024-01-20T11:00:00Z",
      "members": [
        {
          "id": "m27",
          "name": "Patricia Nelson",
          "role": "Product Manager",
          "avatarUrl": "https://i.pravatar.cc/150?img=27",
          "isOnline": true,
          "joinedAt": "2024-01-20T11:00:00Z"
        },
        {
          "id": "m28",
          "name": "Gregory Hill",
          "role": "Product Owner",
          "avatarUrl": "https://i.pravatar.cc/150?img=28",
          "isOnline": false,
          "joinedAt": "2024-01-25T10:00:00Z"
        },
        {
          "id": "m29",
          "name": "Michelle Carter",
          "role": "Business Analyst",
          "avatarUrl": "https://i.pravatar.cc/150?img=29",
          "isOnline": true,
          "joinedAt": "2024-02-01T13:00:00Z"
        },
        {
          "id": "m30",
          "name": "Steven Mitchell",
          "role": "Product Strategist",
          "avatarUrl": "https://i.pravatar.cc/150?img=30",
          "isOnline": true,
          "joinedAt": "2024-02-10T09:00:00Z"
        },
        {
          "id": "m31",
          "name": "Laura Perez",
          "role": "Data Analyst",
          "avatarUrl": "https://i.pravatar.cc/150?img=31",
          "isOnline": false,
          "joinedAt": "2024-02-15T11:30:00Z"
        }
      ]
    },
    {
      "id": "5",
      "name": "Customer Success",
      "description": "Ensuring clients achieve their goals",
      "category": "Support",
      "memberCount": 10,
      "iconEmoji": "💬",
      "colorHex": "#FF8B94",
      "createdAt": "2024-01-05T08:30:00Z",
      "members": [
        {
          "id": "m32",
          "name": "Rebecca Roberts",
          "role": "CS Lead",
          "avatarUrl": "https://i.pravatar.cc/150?img=32",
          "isOnline": true,
          "joinedAt": "2024-01-05T08:30:00Z"
        },
        {
          "id": "m33",
          "name": "Andrew Turner",
          "role": "Support Specialist",
          "avatarUrl": "https://i.pravatar.cc/150?img=33",
          "isOnline": true,
          "joinedAt": "2024-01-10T09:00:00Z"
        },
        {
          "id": "m34",
          "name": "Jennifer Phillips",
          "role": "Account Manager",
          "avatarUrl": "https://i.pravatar.cc/150?img=34",
          "isOnline": false,
          "joinedAt": "2024-01-15T10:30:00Z"
        },
        {
          "id": "m35",
          "name": "Matthew Campbell",
          "role": "Customer Advocate",
          "avatarUrl": "https://i.pravatar.cc/150?img=35",
          "isOnline": true,
          "joinedAt": "2024-01-20T11:00:00Z"
        },
        {
          "id": "m36",
          "name": "Ashley Parker",
          "role": "Onboarding Specialist",
          "avatarUrl": "https://i.pravatar.cc/150?img=36",
          "isOnline": true,
          "joinedAt": "2024-01-25T13:30:00Z"
        },
        {
          "id": "m37",
          "name": "Joshua Evans",
          "role": "Technical Support",
          "avatarUrl": "https://i.pravatar.cc/150?img=37",
          "isOnline": false,
          "joinedAt": "2024-02-01T08:00:00Z"
        },
        {
          "id": "m38",
          "name": "Melissa Edwards",
          "role": "Customer Success Manager",
          "avatarUrl": "https://i.pravatar.cc/150?img=38",
          "isOnline": true,
          "joinedAt": "2024-02-05T09:30:00Z"
        },
        {
          "id": "m39",
          "name": "Christopher Collins",
          "role": "Retention Specialist",
          "avatarUrl": "https://i.pravatar.cc/150?img=39",
          "isOnline": true,
          "joinedAt": "2024-02-10T10:00:00Z"
        },
        {
          "id": "m40",
          "name": "Stephanie Stewart",
          "role": "Support Engineer",
          "avatarUrl": "https://i.pravatar.cc/150?img=40",
          "isOnline": false,
          "joinedAt": "2024-02-15T11:30:00Z"
        },
        {
          "id": "m41",
          "name": "Brian Morris",
          "role": "CS Coordinator",
          "avatarUrl": "https://i.pravatar.cc/150?img=41",
          "isOnline": true,
          "joinedAt": "2024-02-20T14:00:00Z"
        }
      ]
    }
  ]
}
''';
