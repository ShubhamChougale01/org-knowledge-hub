#!/usr/bin/env python3
"""
Data loader script for Org Knowledge Hub Neo4j database.
Executes all Cypher seed files in numbered order.
"""

import os
import sys
from pathlib import Path
from dotenv import load_dotenv
from neo4j import GraphDatabase
from neo4j.exceptions import Neo4jError

# Force UTF-8 on Windows so emojis don't crash the console
if sys.stdout.encoding and sys.stdout.encoding.lower() != "utf-8":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass

# Load environment variables
load_dotenv()

NEO4J_URI = os.getenv('NEO4J_URI', 'bolt://localhost:7687')
NEO4J_USER = os.getenv('NEO4J_USER', 'neo4j')
NEO4J_PASSWORD = os.getenv('NEO4J_PASSWORD', 'coditas123')

SEEDS_DIR = Path(__file__).parent / 'seeds'


def get_driver():
    """Create and return Neo4j driver."""
    try:
        driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
        driver.verify_connectivity()
        return driver
    except Exception as e:
        print(f"❌ Failed to connect to Neo4j at {NEO4J_URI}")
        print(f"   Error: {e}")
        return None


def read_cypher_file(file_path):
    """Read and return content of a Cypher file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"❌ Error reading {file_path}: {e}")
        return None


def execute_cypher(driver, cypher_content, filename):
    """Execute Cypher commands from file content."""
    try:
        with driver.session() as session:
            # Strip comment lines BEFORE splitting by semicolon.
            # Splitting first causes comment lines containing ';' to produce
            # orphaned non-comment fragments that fail as Cypher statements.
            clean_lines = [
                line for line in cypher_content.splitlines()
                if not line.strip().startswith('//')
            ]
            clean_content = '\n'.join(clean_lines)

            statements = [s.strip() for s in clean_content.split(';') if s.strip()]

            for statement in statements:
                session.run(statement)

        print(f"✅ {filename} executed successfully")
        return True
    except Neo4jError as e:
        print(f"❌ {filename} failed with Neo4j error:")
        print(f"   {e}")
        return False
    except Exception as e:
        print(f"❌ {filename} failed with error: {e}")
        return False


def get_node_counts(driver):
    """Get counts of all node types."""
    try:
        with driver.session() as session:
            result = session.run("""
                MATCH (n)
                RETURN labels(n)[0] as label, count(n) as count
                ORDER BY label
            """)
            return {record['label']: record['count'] for record in result}
    except Exception as e:
        print(f"Warning: Could not get node counts: {e}")
        return {}


def main():
    """Main function to load all seed data."""
    print("\n" + "="*60)
    print("🚀 Org Knowledge Hub - Data Loader")
    print("="*60 + "\n")

    # Verify connection
    print(f"📡 Connecting to Neo4j at {NEO4J_URI}...")
    driver = get_driver()

    if not driver:
        print("\n❌ Failed to connect to Neo4j. Please ensure:")
        print("   1. Neo4j is running (docker ps)")
        print("   2. URI is correct in .env file")
        print("   3. Credentials are correct")
        sys.exit(1)

    print("✅ Connected successfully!\n")

    # Find and execute seed files
    seed_files = sorted([f for f in SEEDS_DIR.glob('*.cypher')])

    if not seed_files:
        print(f"❌ No .cypher files found in {SEEDS_DIR}")
        sys.exit(1)

    print(f"📋 Found {len(seed_files)} seed file(s):\n")

    # Filter and sort seed files to ensure correct execution order
    # (load_data.py uses sorted() which respects numeric prefix)
    failed_files = []

    for seed_file in seed_files:
        print(f"  Processing {seed_file.name}...")
        cypher_content = read_cypher_file(seed_file)

        if cypher_content is None:
            failed_files.append(seed_file.name)
            continue

        if not execute_cypher(driver, cypher_content, seed_file.name):
            failed_files.append(seed_file.name)

    print("\n" + "="*60)

    if failed_files:
        print(f"❌ {len(failed_files)} file(s) failed:")
        for f in failed_files:
            print(f"   - {f}")
        print("\n⚠️  Data loading completed with errors.\n")
    else:
        print("✅ All seed files executed successfully!\n")

    # Get final counts
    print("📊 Final Node Counts:")
    print("-" * 60)

    node_counts = get_node_counts(driver)

    if node_counts:
        total = 0
        for label in sorted(node_counts.keys()):
            count = node_counts[label]
            total += count
            print(f"   {label:20s}: {count:4d}")
        print("-" * 60)
        print(f"   {'TOTAL':20s}: {total:4d}")
    else:
        print("   (Could not retrieve counts)")

    # Get relationship counts
    try:
        with driver.session() as session:
            rel_result = session.run("MATCH ()-[r]->() RETURN count(r) as count")
            rel_count = rel_result.single()['count']
            print(f"\n📋 Total Relationships: {rel_count:,}\n")
    except Exception as e:
        print(f"\n⚠️  Could not count relationships: {e}\n")

    driver.close()

    print("="*60)

    if failed_files:
        sys.exit(1)
    else:
        print("✨ Data loading complete! Ready to use your knowledge graph.\n")
        sys.exit(0)


if __name__ == '__main__':
    main()
