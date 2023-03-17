const std = @import("std");

pub fn hashData(b: []const u8) u64 {
    var h = std.hashing.fnv64a.init();
    h.feed(b);
    return h.result();
}

pub const TreeNode = struct {
    left: ?*TreeNode,
    right: ?*TreeNode,
    value: u64,
    data: []const u8,
};

pub fn insert(n: ?*TreeNode, data: []const u8) *TreeNode {
    if (n == null) {
        return &TreeNode{ .left = null, .right = null, .value = hashData(data), .data = data };
    }

    if (hashData(data) < n.value) {
        n.left = insert(n.left, data);
    } else {
        n.right = insert(n.right, data);
    }

    return n;
}

pub fn search(n: ?*TreeNode, data: []const u8) ?*TreeNode {
    if (n == null) {
        return null;
    }

    if (hashData(data) == n.value) {
        return n;
    }

    if (hashData(data) < n.value) {
        return search(n.left, data);
    }

    return search(n.right, data);
}

pub fn delete(n: ?*TreeNode, data: []const u8) ?*TreeNode {
    if (n == null) {
        return null;
    }

    if (hashData(data) < n.value) {
        n.left = delete(n.left, data);
    } else if (hashData(data) > n.value) {
        n.right = delete(n.right, data);
    } else {
        if (n.left == null) {
            return n.right;
        } else if (n.right == null) {
            return n.left;
        } else {
            var successor = n.right;
            while (successor.left != null) : (successor = successor.left) {}
            n.value = successor.value;
            n.data = successor.data;
            n.right = delete(n.right, successor.data);
        }
    }

    return n;
}

pub fn update(n: ?*TreeNode, data: []const u8, newData: []const u8) ?*TreeNode {
    if (n == null) {
        return null;
    }

    if (hashData(data) == n.value) {
        n.data = newData;
    } else if (hashData(data) < n.value) {
        n.left = update(n.left, data, newData);
    } else {
        n.right = update(n.right, data, newData);
    }

    return n;
}
