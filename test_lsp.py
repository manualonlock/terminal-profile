import os
import sys
from dataclasses import dataclass, field
from typing import Optional
from enum import Enum


class Priority(Enum):
    LOW = 1
    MEDIUM = 2
    HIGH = 3
    CRITICAL = 4


@dataclass
class Task:
    title: str
    description: str
    priority: Priority
    completed: bool = False
    tags: list[str] = field(default_factory=list)

    def mark_done(self):
        self.completed = True

    def add_tag(self, tag: str):
        if tag not in self.tags:
            self.tags.append(tag)

    def __str__(self):
        status = "done" if self.completed else "pending"
        return f"[{status}] {self.title} ({self.priority.name})"


class TaskManager:
    def __init__(self, owner: str):
        self.owner = owner
        self._tasks: list[Task] = []

    @property
    def pending_tasks(self) -> list[Task]:
        return [t for t in self._tasks if not t.completed]

    @property
    def completed_tasks(self) -> list[Task]:
        return [t for t in self._tasks if t.completed]

    def add_task(self, task: Task) -> None:
        self._tasks.append(task)

    def find_by_title(self, query: str) -> Optional[Task]:
        for task in self._tasks:
            if query.lower() in task.title.lower():
                return task
        return None

    def find_by_tag(self, tag: str) -> list[Task]:
        return [t for t in self._tasks if tag in t.tags]

    def find_by_priority(self, priority: Priority) -> list[Task]:
        return [t for t in self._tasks if t.priority == priority]

    def complete_task(self, title: str) -> bool:
        task = self.find_by_title(title)
        if task is None:
            return False
        task.mark_done()
        return True

    def summary(self) -> dict[str, int]:
        return {
            "total": len(self._tasks),
            "pending": len(self.pending_tasks),
            "completed": len(self.completed_tasks),
        }

    def print_report(self):
        print(f"Task Report for {self.owner}")
        print("=" * 40)
        stats = self.summary()
        print(f"Total: {stats['total']}, Pending: {stats['pending']}, Done: {stats['completed']}")
        print()
        for priority in Priority:
            tasks = self.find_by_priority(priority)
            if tasks:
                print(f"  {priority.name}:")
                for task in tasks:
                    print(f"    {task}")


def create_sample_data(manager: TaskManager) -> None:
    tasks = [
        Task("Setup CI pipeline", "Configure GitHub Actions", Priority.HIGH, tags=["devops"]),
        Task("Write unit tests", "Cover auth module", Priority.MEDIUM, tags=["testing"]),
        Task("Update README", "Add install instructions", Priority.LOW, tags=["docs"]),
        Task("Fix login bug", "Users cannot reset password", Priority.CRITICAL, tags=["bug"]),
        Task("Refactor database layer", "Switch to async queries", Priority.MEDIUM, tags=["backend"]),
    ]
    for task in tasks:
        manager.add_task(task)


def main():
    manager = TaskManager(owner="Yahor")
    create_sample_data(manager)

    manager.complete_task("Update README")
    manager.complete_task("Fix login bug")

    manager.print_report()

    print()
    bug_tasks = manager.find_by_tag("bug")
    print(f"Bug tasks: {[str(t) for t in bug_tasks]}")


if __name__ == "__main__":
    main()
