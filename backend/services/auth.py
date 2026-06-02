"""
JWT authentication and RBAC service.

Token structure:
  {
    "user_id":      "EMP-TECH-010",
    "full_name":    "Shubham Chougale",
    "email":        "shubham.morya@coditas.com",
    "department":   "Tech",
    "access_level": "L3",   // L1=Admin, L2=Manager, L3=Employee, L4=System
    "exp":          1234567890
  }

RBAC levels:
  L1 Admin     → HR dept + C-Suite       → all fields visible
  L2 Manager   → Dept Heads, PMs         → own team's PII visible
  L3 Employee  → All staff               → no PII except own profile
  L4 System    → Default chatbot context → no PII at all
"""

from datetime import datetime, timedelta, timezone
from typing import Optional, Literal

from jose import jwt, JWTError
from passlib.context import CryptContext

from config import JWT_SECRET, JWT_ALGORITHM, JWT_EXPIRES_HOURS


# ─── Password hashing (for future user table) ───────────────────────────
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(plain: str) -> str:
    """Hash a plaintext password using bcrypt."""
    return pwd_context.hash(plain)


def verify_password(plain: str, hashed: str) -> bool:
    """Check if a plaintext password matches its hash."""
    return pwd_context.verify(plain, hashed)


# ─── Access levels ──────────────────────────────────────────────────────
AccessLevel = Literal["L1", "L2", "L3", "L4"]

PII_FIELDS = ["phone", "dob", "address"]


def can_see_pii(access_level: str, viewing_own_profile: bool = False) -> bool:
    """
    Decide whether PII fields should be returned to the caller.
    - L1 (Admin) → always sees PII
    - L2 (Manager) → sees PII (controller decides if it's their team)
    - L3 (Employee) → sees PII only when viewing their own profile
    - L4 (System/default) → never sees PII
    """
    if access_level == "L1":
        return True
    if access_level == "L2":
        return True
    if access_level == "L3" and viewing_own_profile:
        return True
    return False


def mask_pii(record: dict, access_level: str, viewing_own_profile: bool = False) -> dict:
    """Remove PII fields from a record if the access level does not permit them."""
    if can_see_pii(access_level, viewing_own_profile):
        return record
    masked = {k: v for k, v in record.items() if k not in PII_FIELDS}
    return masked


def mask_pii_list(records: list[dict], access_level: str) -> list[dict]:
    """Apply mask_pii to every record in a list."""
    if can_see_pii(access_level):
        return records
    return [mask_pii(r, access_level) for r in records]


# ─── JWT token creation and validation ──────────────────────────────────
def create_token(
    user_id: str,
    full_name: str,
    email: str,
    department: str,
    access_level: AccessLevel = "L3",
    expires_hours: Optional[int] = None,
) -> tuple[str, int]:
    """
    Create a signed JWT token.
    Returns: (token, expires_in_seconds)
    """
    expires_hours = expires_hours or JWT_EXPIRES_HOURS
    expiry = datetime.now(timezone.utc) + timedelta(hours=expires_hours)
    payload = {
        "user_id":      user_id,
        "full_name":    full_name,
        "email":        email,
        "department":   department,
        "access_level": access_level,
        "exp":          expiry,
    }
    token = jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return token, expires_hours * 3600


def decode_token(token: str) -> Optional[dict]:
    """
    Decode and verify a JWT token. Returns None if invalid or expired.
    Strips the 'Bearer ' prefix automatically.
    """
    if not token:
        return None
    if token.lower().startswith("bearer "):
        token = token[7:]
    try:
        return jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
    except JWTError:
        return None


# ─── Helper: derive access level from employee record ───────────────────
def derive_access_level(department: str, role_title: str) -> AccessLevel:
    """
    Map an employee's department + role to an access level.
    Used during login when issuing the token.
    """
    role_title_lower = (role_title or "").lower()

    # L1 Admin — HR department + C-Suite
    if department == "HR":
        return "L1"
    if any(c in role_title_lower for c in ["ceo", "cto", "cfo", "cho", "chief"]):
        return "L1"

    # L2 Manager — Heads, Managers, PMs
    if any(t in role_title_lower for t in ["head", "manager", "lead"]):
        return "L2"

    # L3 — everyone else
    return "L3"
